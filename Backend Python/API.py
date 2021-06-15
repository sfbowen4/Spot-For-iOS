#Stephen Bowen 2021
#System modules
import time

# Boston Dynamics modules
from bosdyn.api.spot import robot_command_pb2 as spot_command_pb2
from bosdyn.client.estop import EstopEndpoint, EstopKeepAlive, EstopClient
from bosdyn.client.robot_state import RobotStateClient
from bosdyn.client.robot_command import RobotCommandBuilder, RobotCommandClient
from bosdyn.client.lease import LeaseClient, LeaseKeepAlive
import bosdyn.client.util

#Custom modules
from estop import EstopNoGui

class SpotAPI():

    def __init__(self, username, password, spotIP):
        # Gather and assign credntials and Spot's IP
        self.__username = username
        self.__password = password
        self.spotIP = spotIP
        
        # Set power state for Spot
        self._isPoweredOn = False

    # Authenticate user and build required interfaces
    def auth(self):
        try:
            # Create robot object
            sdk = bosdyn.client.create_standard_sdk('Spot for iOS')
            self._robot = sdk.create_robot(self.spotIP)
            self._robot.authenticate(self.__username, self.__password)
            # Create estop client for the robot
            estop_client = self._robot.ensure_client(EstopClient.default_service_name)

            # Create estop endpoint
            self.estop_nogui = EstopNoGui(estop_client, 60, 'Estop iOS')

            # Create robot state, command, and lease clients
            self._state_client = self._robot.ensure_client(RobotStateClient.default_service_name)
            self._robot_command_client = self._robot.ensure_client(RobotCommandClient.default_service_name)
            self._lease_client = self._robot.ensure_client(LeaseClient.default_service_name)

            # Acquire and retain lease and robot id
            self._lease = self._lease_client.acquire()
            # Construct our lease keep-alive object, which begins RetainLease calls in a thread.
            self._lease_keepalive = LeaseKeepAlive(self._lease_client)
            self._robot_id = self._robot.get_id()
        except:
            return False

    # Power Spot on/off
    def togglePower(self):
        try:
            if self._isPoweredOn:
                self._robot.power_off()
                self._isPoweredOn = False
            else:
                self._robot.power_on()
                self._isPoweredOn = True
            return self._isPoweredOn
        except:
            return self._isPoweredOn

    # Trigger EStop
    def eStop(self):
        return self.estop_nogui.stop()

    # Clear EStop
    def clearEStop(self):
        status = self.estop_nogui.allow()
        try: 
            self._robot.power_on()
            return status
        except:
            return status

    # End connection to robot
    def endConnection(self):
        # Return lease and end Estop coverage
        self._lease_client.return_lease(self._lease)
        self._lease_keepalive.shutdown()
        self._lease_keepalive = None
        self.estop_nogui.estop_keep_alive.shutdown()
        return True

    # Sets the pose of a standing Spot
    def setPose(self, yaw=float, roll=float, pitch=float):
        try:
            footprint_R_body = bosdyn.geometry.EulerZXY(yaw=yaw, roll=roll, pitch=pitch)
            cmd = RobotCommandBuilder.synchro_stand_command(footprint_R_body=footprint_R_body)
            self._robot_command_client.robot_command(cmd)
            return True
        except:
            return False

    # Receive, parse, and execute a command as a string
    def genericMovement(self, request):
        # Set the default speed and timing for executing velocity commands
        VELOCITY_BASE_SPEED = 0.5  # m/s
        VELOCITY_BASE_ANGULAR = 0.8  # rad/sec
        VELOCITY_CMD_DURATION = 0.6  # seconds
        
        requestLibrary = {
        'sit': RobotCommandBuilder.synchro_sit_command(params=spot_command_pb2.MobilityParams(locomotion_hint=spot_command_pb2.HINT_AUTO, stair_hint=0)), # SIT
        'stand': RobotCommandBuilder.synchro_stand_command(params=spot_command_pb2.MobilityParams(locomotion_hint=spot_command_pb2.HINT_AUTO, stair_hint=0)), # STAND
        'W': RobotCommandBuilder.synchro_velocity_command(v_x=VELOCITY_BASE_SPEED, v_y=0, v_rot=0), # FORWAWRD
        'A': RobotCommandBuilder.synchro_velocity_command(v_x=0, v_y=VELOCITY_BASE_SPEED, v_rot=0), # LEFT
        'S': RobotCommandBuilder.synchro_velocity_command(v_x=-VELOCITY_BASE_SPEED, v_y=0, v_rot=0), # BACKWARD
        'D': RobotCommandBuilder.synchro_velocity_command(v_x=0, v_y=-VELOCITY_BASE_SPEED, v_rot=0), # RIGHT
        'Q': RobotCommandBuilder.synchro_velocity_command(v_x=0,v_y=0,v_rot=VELOCITY_BASE_ANGULAR), # TURN LEFT
        'E': RobotCommandBuilder.synchro_velocity_command(v_x=0,v_y=0,v_rot=-VELOCITY_BASE_ANGULAR) # TURN RIGHT
    }
        try:
            self._robot_command_client.robot_command_async(command=requestLibrary[request],end_time_secs=time.time()+VELOCITY_CMD_DURATION)
            return True
        except:
            return False
