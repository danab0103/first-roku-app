sub init()
    m.pokemonPoster = m.top.findNode("pokemonPoster")
    m.pokemonLabel = m.top.findNode("pokemonLabel")
end sub

sub showContent()
    pokemonContent = m.top.itemContent
    m.pokemonPoster.uri = pokemonContent.url
    m.pokemonLabel.text = pokemonContent.title
end sub
