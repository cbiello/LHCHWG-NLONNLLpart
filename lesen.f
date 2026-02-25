      program readit
      implicit double precision (a-h,o-z)
      character*10 aaa

      open(95,file='BPT_summary4_NLO+NNLLpart+ybyt.dat')
      read(95,*)
      read(95,*)
      read(95,*)
      write(96,*)'M_H [GeV]    ','sigma [pb]      ','THU [%]   ',
     .           '+(PDF+as+mb) [%]  ','-(PDF+as+mb) [%]'
100   continue
      read(95,*,end=101)amh,xmuf,aaa,sig,rfu,xmu,amb,pdfp,pdfm,asm,asp
      thu = dsqrt(rfu**2+xmu**2)/sig*100
      pup = dsqrt(amb**2+pdfp**2+asp**2)/sig*100
      pum = dsqrt(amb**2+pdfm**2+asm**2)/sig*100
      write(96,'(F7.1,5x,G12.4,3x,F7.1,3x,F7.1,11x,F7.1)')
     .         amh,sig,thu,pup,-pum
      goto 100

101   continue

      stop
      end
