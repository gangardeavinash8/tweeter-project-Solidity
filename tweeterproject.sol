// SPDX-License-Identifier: GPL-3.0 

pragma solidity >= 0.5.0 < 0.9.0;

contract tweeterContract{

    struct Tweet{
        uint id;
        address author;         
        string content;
        uint createdAt;                                    //time
    }

    struct Message{
        uint id;
        string content;
        address from;
        address to;
        uint createdAt;
    }
 
    mapping(uint => Tweet) public tweets;             //mapping of num and tweets at perticular index 
    mapping(address => uint[]) public tweetsOf;       //mapping of twieets and its addrsss at index 
    mapping(address => Message[]) public conversations;          //to store massage array
    mapping(address => mapping(address=>bool)) public operators;
    mapping(address => address[]) public following;              //to store the follower

    uint nextId;
    uint nextMessageId;
    
    function _tweet(address _from,string memory _content) internal {
         tweets[nextId]=Tweet(nextId,_from,_content,block.timestamp);
         tweetsOf[_from].push(nextId);
         nextId++;
    }

    function _sendMessage(address _from , address _to,string memory _content )internal{
    conversations[_from].push(Message(nextMessageId,_content,_from,_to,block.timestamp));
    nextMessageId++;
    }

    function tweet(string memory _content) public {
        _tweet(msg.sender,_content);                   //jo bhi apne account se msg karana chahta he vo iss fun ko call karega
    }

    function  tweet(address _from,string memory _content)public{
        _tweet(_from,_content);                         //this fun call by thoes persons who have access
    }

     function sendMessage(address _to,string memory _content)  public {
         _sendMessage(msg.sender,_to,_content);
     }

     function sendMessage(address _from,address _to,string memory _content) public{
         _sendMessage(_from,_to,_content);
     }

    function follow(address _followed) public {
     following[msg.sender].push(_followed);
    }

    function allow(address _operator) public {
        operators[msg.sender][_operator]=true;
    }

    function disallow(address _operator) public {
        operators[msg.sender][_operator]=false;
    }

    function getLatestTweest(uint count) view public returns (Tweet[] memory) {
        require(count > 0 && count <=nextId,"count is not proper");
        Tweet[] memory _tweets=new Tweet[](count);          //length of the array is equal to count 
        uint j;
        for(uint i=nextId-count;i<nextId;i++){
        Tweet storage _structure =tweets[i];
         _tweets[j]=Tweet(_structure.id,
         _structure.author,
         _structure.content,
         _structure.createdAt);
         j++;
        }
        return _tweets;


        }

        function getLatestOfUser(address _user,uint count) public view {
            Tweet[] memory _tweets=new Tweet[](count);
          
            uint[] memory ids= tweetsOf[_user];
            require(count > 0 && count <= nextId,"count is not defined");
            uint j;
            for(uint i=tweetsOf[_user].length-count;i<tweetsOf[_user].length;i++){
             Tweet storage _structure=tweets[ids[i]];
             _tweets[j]=Tweet(_structure.id,
             _structure.author,
             _structure.content,
             _structure.createdAt);
             j++;
            }
        }
    
}