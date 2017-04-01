pragma solidity ^0.4.0;

contract Points {
    struct Generation{
        address institut;     // adresse de l'institut
        uint points;          //points générés
    }
    
    struct Transfert{
        address institut;     //adresse de l'institut
        address actuaire;     //adresse de l'actuaire
        uint pointsT;          //nombre de points tranférés
    }
    
    struct Proposition{
        bytes32 nom;          //nom de l'action menée
        uint points;
    }
    
    struct Actuaire{
        address actuaire;     //adresse de l'actuaire
        uint pointsCount;     //nombre de points accumulés
        bool statut;          //statut de l'actuaire, délégué par l'institut, par rapport au nombre de points cumulés
    }
    
    struct Soumission{
        address institut;     //adresse de l'institut
        address actuaire;     //adresse de l'actuaire
        bytes32 nom;          //nom de l'action menée
        string desc;          //description de l'action menée
        uint heure;           //nombre d'heures passées sur l'action
    }
     address public institut;
     address public actuaire;
     
    //Cela déclare une variable qui stocke un 'Actuaire' struct pour chaque adresse possible
    //mapping(address => Actuaire) public actuaires;    
    
    // Un tableau dynamique des propositions
    Proposition[] public propositions;
    
    //Un tableau dynamique des soumissions
    Soumission[] public soumissions;
    
    Actuaire [] public actuaires;
    
    
    
    //Vérifie que c'est l'institut
    modifier isInstitute() {
        if(msg.sender != institut) throw;_;
    }
    
     modifier isActuaire() {
        if (msg.sender != actuaire) throw;_;
    }

    
    function Points(bytes32[] propositionsNoms, uint points) {
        institut = msg.sender;
        

        // For each of the provided proposal names,
        // create a new proposal object and add it
        // to the end of the array.
        for (uint i = 0; i < propositionsNoms.length; i++) {
            // `Proposal({...})` creates a temporary
            // Proposal object and `proposals.push(...)`
            // appends it to the end of `proposals`.
            propositions.push(Proposition({
                nom : propositionsNoms[i],
                points : 0
            }));
        }
    }
   
     
    function Actions (bytes32[] soumissionsNoms, bytes32[] propositionsNoms){
        
        actuaire = msg.sender;
        for (uint i = 0; i < propositionsNoms.length; i++) {
        propositionsNoms[i] = soumissionsNoms[i];
            // `Proposal({...})` creates a temporary
            // Proposal object and `proposals.push(...)`
            // appends it to the end of `proposals`.
            soumissions.push(Soumission({
                actuaire : actuaires[i].actuaire,
                institut : institut,
                nom : propositionsNoms[i],
                desc : "",
                heure : 0
            }));
        }
        
    }
    
      


//Institut crédite compte actuaire
function transfer (address aKey, uint amount) isInstitute() {
        bool existAccount=false;
        for (uint i=0; i<actuaires.length; i++) {
            if (actuaires[i].actuaire == aKey){
                
                actuaires[i].pointsCount = actuaires[i].pointsCount+amount;
            existAccount = true;
            }
            
        }
        if (!existAccount) {
            actuaires.push(Actuaire({
                    actuaire: aKey,
                    pointsCount : amount,
                    statut : false
                }));
        }
    }


function certification(address aKey) returns (bool) {
        bool statut=false;
        for (uint i=0; i<actuaires.length; i++) {
            if (actuaires[i].actuaire==aKey){
                if(actuaires[i].pointsCount>=180){
                statut = true;
                }
            }
            
        }
        return statut;
    }
