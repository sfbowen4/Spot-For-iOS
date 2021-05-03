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

    def __init__(self, username, password):
        # Create robot object
        print("Creating Robot")
        sdk = bosdyn.client.create_standard_sdk('estop_nogui')
        self._robot = sdk.create_robot("192.168.80.3")
        self._robot.authenticate(username, password)
        # Create estop client for the robot
        estop_client = self._robot.ensure_client(EstopClient.default_service_name)

        # Create nogui estop
        self.estop_nogui = EstopNoGui(estop_client, 60, "Estop iOS")

        # Create robot state, command, and lease clients
        self._state_client = self._robot.ensure_client(RobotStateClient.default_service_name)
        self._robot_command_client = self._robot.ensure_client(RobotCommandClient.default_service_name)
        self._lease_client = self._robot.ensure_client(LeaseClient.default_service_name)

        # Acquire and retain lease and robot id
        self._lease = self._lease_client.acquire()
        # Construct our lease keep-alive object, which begins RetainLease calls in a thread.
        self._lease_keepalive = LeaseKeepAlive(self._lease_client)
        self._robot_id = self._robot.get_id()

        # Power robot on
        self._robot.power_on() # Power robot on. Call blocks for 20 seconds before expiring on failure

    # Trigger EStop
    def stop(self):
        self.estop_nogui.stop()

    # Clear EStop
    def ClearStop(self):
        self.estop_nogui.allow()
        self._robot.power_on()

    # End connection to robot
    def End(self):
        # Return lease and end Estop coverage
        self._lease_client.return_lease(self._lease)
        self._lease_keepalive.shutdown()
        self._lease_keepalive = None
        self.estop_nogui.estop_keep_alive.shutdown()

    # Receive, parse, and execute a command as a string
    def GenericRequest(self, request):
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
        self._robot_command_client.robot_command_async(command=requestLibrary[request],end_time_secs=(time.time()+VELOCITY_CMD_DURATION))