#setWavPlayer('"C:/Program Files/Windows Media Player/wmplayer.exe"')
library(sound)
sinewave<-sound::Sine(freq=30,dur=1,rate=100000,bits=24,channels=2)
sawtoothwave<-sound::Sawtooth(freq=10,dur=1,rate=100000,bits=24,channels=2,reverse=FALSE)
squarewave<-sound::Square(freq=10,dur=1,rate=100000,bits=24,channels=2,upPerc=50)
silence<-sound::Silence(dur=1,rate=100000,bits=24,channels=2)
noice<-sound::Noise(dur=1,rate=100000,bits=16,channels=2)

plot(sinewave)
plot(sawtoothwave)
plot(squarewave)
plot(silence)
plot(noice)

# sound::play(sinewave)
# sound::play(sawtoothwave)
# sound::play(squarewave)
# sound::play(silence)
# sound::play(noice)

library(seewave)
library(rgl)
wav<-2*(seq(0,100,length=500000)%%1)
savewav(wav,f=2000)
wav<-data.frame(wav)
wav.sound<-sound::as.Sample(wav$wav,rate=44100,bits=16)
wav.sound$sound<-wav.sound$sound-1.5
sound::play(wav.sound)
plot(wav.sound)

ws<-data.frame(t(wav.sound$sound))
spectro3D(ws$t.wav.sound.sound.,f=320,palette=spectro.colors)

rgl.viewpoint(45,0)
step <- seq(-90,271,by=1)
for (i in step){
  rgl.viewpoint(i,(i/4.5)+30)
  filename <- paste("picA",which(step==i),".png",sep="")
  rgl.snapshot(filename)
}

rgl.viewpoint(270,90)
step <- seq(270,-90,by=-4)
for (i in step){
  rgl.viewpoint(i,(i/4.5)+30)
  filename <- paste("picB",which(step==i),".png",sep="")
  rgl.snapshot(filename)
}

for(i in 1:length(degrees)){
  view3d(degrees[i],phi=45) # pick the angle of view
  rgl.snapshot(paste(paste("/file_directory/filename","-",formatC(i,digits=3,flag="0"),sep=""),"png",sep="."))
}

movie3d(spin3d(),duration=20)
