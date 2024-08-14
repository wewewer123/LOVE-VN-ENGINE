Name = "Sam"
NameChangable = true
ScriptContainer = {
    --{
    --    Name = 0, 
    --    text = "", 
    --    bg = 0, 
    --    music = 0, 
    --    question = {text yes, goto yes, text no, goto no}, 
    --    question = {"I'll say yes", "This is where yes will end up", "I'll say no", "This is where no will end up"}, 
    --    move = 0, 
    --    char1 = 0, 
    --    char2 = 0
    --},
    { 
        text = "It's only when I hear the sounds of shuffling feet and supplies being put away that I realize that the lecture's over.", 
        bg = "bg_lecturehall.jpg", 
        music = "ilurock.mp3",   
    },
    {  
        text = "Professor Eileen's lectures are usually interesting, but today I just couldn't concentrate on it.",  
    },
    { 
        text = "I've had a lot of other thoughts on my mind...thoughts that culminate in a question.",   
    },
    { 
        text = "It's a question that I've been meaning to ask a certain someone.",   
    },
    { 
        text = "When we come out of the university, I spot her right away.", 
        bg = "bg_uni.jpg",  
    },
    { 
        text = "I've known Sylvie since we were kids. She's got a big heart and she's always been a good friend to me.",   
        char2 = "sylvie green normal.png"
    },
    { 
        text = "But recently... I've felt that I want something more.",   
    },
    { 
        text = "More than just talking, more than just walking home together when our classes end.",   
    },
    { 
        text = "As soon as she catches my eye, I decide...",   
        question = {"To ask her right away.", 10, "To ask her later.", 75}, 
    },
    {
        Name = "Sylvie", 
        text = "Hi there! How was class?",   
        char2 = "sylvie green smile.png"
    },
    {
        Name = "Name", 
        text = "Good...",   
    },
    { 
        text = "I can't bring myself to admit that it all went in one ear and out the other.",   
    },
    {
        Name = "Name", 
        text = "Are you going home now? Wanna walk back with me?",   
    },
    {
        name = "Sylvie", 
        text = "Sure!",   
    },
    { 
        text = "After a short while, we reach the meadows just outside the neighborhood where we both live.", 
        bg = "bg_meadow.jpg",  
        char2 = "nothing"
    },
    { 
        text = "It's a scenic view I've grown used to. Autumn is especially beautiful here.",   
    },
    { 
        text = "When we were children, we played in these meadows a lot, so they're full of memories.",   
    },
    {
        Name = "Name", 
        text = "Hey... Umm...",   
    },
    { 
        text = "She turns to me and smiles. She looks so welcoming that I feel my nervousness melt away. I'll ask her!",   
        char2 = "sylvie green smile.png"
    },
    {
        Name = "Name", 
        text = "Ummm... Will you... ",   
    },
    {
        Name = "Name", 
        text = "Will you be my artist for a visual novel?",   
    },
    { 
        text = "Silence.",   
        char2 = "sylvie green surprised.png"
    },
    { 
        text = "She looks so shocked that I begin to fear the worst. But then...",   
    },
    {
        name = "Sylvie", 
        text = "Sure, but what is a \"Visual Novel?\"",   
        question = {"It's an interactive book.", "It's like an interactive book that you can read on a computer or a console.", "It's a videogame.", "It's a kind of videogame you can play on your computer or a console."}, 
        char2 = "sylvie green smile.png"
    },
    {
        Name = "Name", 
        text = "It's like an interactive book that you can read on a computer or a console.",   
        char2 = "sylvie green surprised.png"
    },
    {
        name = "Sylvie", 
        text = "Interactive?",   
    },
    {
        Name = "Name", 
        text = "You can make choices that lead to different events and endings in the story.",   
    },
    {
        name = "Sylvie", 
        text = "So where does the 'visual' part come in?",   
    },
    {
        Name = "Name", 
        text = "Visual novels have pictures and even music, sound effects, and sometimes voice acting to go along with the text.",   
    },
    {
        name = "Sylvie", 
        text = "I see! That certainly sounds like fun. I actually used to make webcomics way back when, so I've got lots of story ideas.",   
        char2 = "sylvie green smile.png"
    },
    {
        Name = "Name", 
        text = "That's great! So...would you be interested in working with me as an artist?",   
    },
    {
        name = "Sylvie", 
        text = "I'd love to!",   
    },
    { 
        text = "", --" ggg 48", 
        move = 48
    },
    { 
        text = "",   
    },
    { 
        text = "",   
    },
    {
        Name = "Name", 
        text = "It's a kind of videogame you can play on your computer or a console.",   
    },
    {
        Name = "Name", 
        text = "Visual novels tell a story with pictures and music.",   
    },
    {
        Name = "Name", 
        text = "Sometimes, you also get to make choices that affect the outcome of the story.",   
    },
    {
        name = "Sylvie", 
        text = "So it's like those choose-your-adventure books?",   
    },
    {
        Name = "Name", 
        text = "Exactly! I've got lots of different ideas that I think would work.",   
    },
    {
        Name = "Name", 
        text = "And I thought maybe you could help me...since I know how you like to draw.",   
        char2 = "sylvie green normal.png"
    },
    {
        Name = "Name", 
        text = "It'd be hard for me to make a visual novel alone.",   
    },
    {
        name = "Sylvie", 
        text = "Well, sure! I can try. I just hope I don't disappoint you.",   
    },
    {
        Name = "Name", 
        text = "You know you could never disappoint me, Sylvie.",   
    },
    { 
        text = "", --" ggg And so, we become a visual novel creating duo.", 
        move = "And so, we become a visual novel creating duo."
    },
    { 
        text = "",   
        char2 = "nothing"
    },
    { 
        text = "",   
    },
    { 
        text = "And so, we become a visual novel creating duo.", 
        bg = "black.png", 
        char2 = "nothing"
    },
    { 
        text = "Over the years, we make lots of games and have a lot of fun making them.", 
        bg = "bg_club.jpg",  
    },
    { 
        text = "Our first game is based on one of Sylvie's ideas, but afterwards I get to come up with stories of my own, too.",   
    },
    { 
        text = "We take turns coming up with stories and characters and support each other to make some great games!", 
    },
    { 
        text = "And one day...", 
    },
    {
        name = "Sylvie", 
        text = "Hey...", 
        bg = "bg_club.jpg",
        char2 = "sylvie blue normal.png"
    },
    {
        Name = "Name", 
        text = "Yes?",   
    },
    {
        name = "Sylvie", 
        text = "Will you marry me?",   
        char2 = "sylvie blue smile.png"
    },
    {
        Name = "Name", 
        text = "What? Where did this come from?",   
    },
    {
        name = "Sylvie", 
        text = "Come on, how long have we been dating?",   
        char2 = "sylvie blue surprised.png"
    },
    {
        Name = "Name", 
        text = "A while...",   
    },
    {
        name = "Sylvie", 
        text = "These last few years we've been making visual novels together, spending time together, helping each other...",   
        char2 = "sylvie blue smile.png"
    },
    {
        name = "Sylvie", 
        text = "I've gotten to know you and care about you better than anyone else. And I think the same goes for you, right?",   
    },
    {
        Name = "Name", 
        text = "Sylvie...",   
    },
    {
        name = "Sylvie", 
        text = "But I know you're the indecisive type. If I held back, who knows when you'd propose?",   
        char2 = "sylvie blue giggle.png"
    },
    {
        name = "Sylvie", 
        text = "So will you marry me?",   
        char2 = "sylvie blue normal.png"
    },
    {
        Name = "Name", 
        text = "Of course I will! I've actually been meaning to propose, honest!",   
    },
    {
        name = "Sylvie", 
        text = "I know, I know.",   
    },
    {
        Name = "Name", 
        text = "I guess... I was too worried about timing. I wanted to ask the right question at the right time.",   
    },
    {
        name = "Sylvie", 
        text = "You worry too much. If only this were a visual novel and I could pick an option to give you more courage!",   
        char2 = "sylvie blue giggle.png"
    },
    { 
        text = "We get married shortly after that.", 
        bg = "black.png",  
        char2 = "nothing"
    },
    { 
        text = "Our visual novel duo lives on even after we're married...and I try my best to be more decisive.",   
    },
    { 
        text = "Together, we live happily ever after even now.",   
    },
    { 
        text = "123quit123",   
    },
    { 
        text = "",   
    },
    { 
        text = "",   
    },
    { 
        text = "",   
    },
    { 
        text = "I can't get up the nerve to ask right now. With a gulp, I decide to ask her later.",   
    },
    { 
        text = "But I'm an indecisive person.", 
        bg = "black.png", 
        music = "nitizyou1.mp3",  
        char2 = "nothing"
    },
    { 
        text = "I couldn't ask her that day and I end up never being able to ask her.",   
    },
    { 
        text = "I guess I'll never know the answer to my question now...",   
    }
} 

return { ScriptContainer, Name, NameChangable }