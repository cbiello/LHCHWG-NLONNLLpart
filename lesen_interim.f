      program AAreadit
      implicit double precision (a-h,o-z)
      character*10 aaa
      common/energy/i135
c-- 0 = 13 TeV     1 = 13.5 Tev
      i135 = 1
      ilog = 0
      if(i135.eq.0)then
       write(6,*)'13.0 TeV'
       write(6,*)'========'
       open(95,file='Ecm_13000/BPT_summary4_NLO+NNLLpart+ybyt.dat')
       do i=1,35
        read(95,*)
       enddo
      else
       write(6,*)'13.5 TeV'
       write(6,*)'========'
       open(95,file='Ecm_13500/BPT_summary4_NLO+NNLLpart+ybyt.dat')
       do i=1,3
        read(95,*)
       enddo
      endif
      read(95,*)amh,xmuf,aaa,sig11,rfu,xmu,amb,pdfp,pdfm,asm,asp
      thu11 = dsqrt(rfu**2+xmu**2)
      pup11 = dsqrt(amb**2+pdfp**2+asp**2)
      pum11 = dsqrt(amb**2+pdfm**2+asm**2)
      write(6,*)amh,sig11,'+-',thu11,pup11,-pum11
      read(95,*)amh,xmuf,aaa,sig12,rfu,xmu,amb,pdfp,pdfm,asm,asp
      thu12 = dsqrt(rfu**2+xmu**2)
      pup12 = dsqrt(amb**2+pdfp**2+asp**2)
      pum12 = dsqrt(amb**2+pdfm**2+asm**2)
      write(6,*)amh,sig12,'+-',thu12,pup12,-pum12
      if(i135.eq.0)then
       do i=1,3
        read(95,*)
       enddo
       read(95,*)amh,xmuf,aaa,sig13,rfu,xmu,amb,pdfp,pdfm,asm,asp
       thu13 = dsqrt(rfu**2+xmu**2)
       pup13 = dsqrt(amb**2+pdfp**2+asp**2)
       pum13 = dsqrt(amb**2+pdfm**2+asm**2)
       write(6,*)amh,sig13,'+-',thu13,pup13,-pum13
      endif

      write(6,*)
      write(6,*)
      write(6,*)'14.0 TeV'
      write(6,*)'========'
      open(95,file='Ecm_14000/BPT_summary4_NLO+NNLLpart+ybyt.dat')
      do i=1,35
       read(95,*)
      enddo
      read(95,*)amh,xmuf,aaa,sig21,rfu,xmu,amb,pdfp,pdfm,asm,asp
      thu21 = dsqrt(rfu**2+xmu**2)
      pup21 = dsqrt(amb**2+pdfp**2+asp**2)
      pum21 = dsqrt(amb**2+pdfm**2+asm**2)
      write(6,*)amh,sig21,'+-',thu21,pup21,-pum21
      read(95,*)amh,xmuf,aaa,sig22,rfu,xmu,amb,pdfp,pdfm,asm,asp
      thu22 = dsqrt(rfu**2+xmu**2)
      pup22 = dsqrt(amb**2+pdfp**2+asp**2)
      pum22 = dsqrt(amb**2+pdfm**2+asm**2)
      write(6,*)amh,sig22,'+-',thu22,pup22,-pum22
      if(i135.eq.0)then
       do i=1,3
        read(95,*)
       enddo
       read(95,*)amh,xmuf,aaa,sig23,rfu,xmu,amb,pdfp,pdfm,asm,asp
       thu23 = dsqrt(rfu**2+xmu**2)
       pup23 = dsqrt(amb**2+pdfp**2+asp**2)
       pum23 = dsqrt(amb**2+pdfm**2+asm**2)
       write(6,*)amh,sig23,'+-',thu23,pup23,-pum23
      endif

      write(6,*)
      write(6,*)
      write(6,*)'13.6 TeV'
      write(6,*)'========'
      amh = 125
      if(ilog.eq.0)then
       sig = ff(sig11,sig21)
       thu = ff(thu11,thu21)
       pup = ff(pup11,pup21)
       pum = ff(pum11,pum21)
      else
       sig = dexp(ff(dlog(sig11),dlog(sig21)))
       thu = dexp(ff(dlog(thu11),dlog(thu21)))
       pup = dexp(ff(dlog(pup11),dlog(pup21)))
       pum = dexp(ff(dlog(pum11),dlog(pum21)))
      endif
      write(6,*)amh,sig,'+-',thu,pup,-pum
      amh = 125.09d0
      if(ilog.eq.0)then
       sig = ff(sig12,sig22)
       thu = ff(thu12,thu22)
       pup = ff(pup12,pup22)
       pum = ff(pum12,pum22)
      else
       sig = dexp(ff(dlog(sig12),dlog(sig22)))
       thu = dexp(ff(dlog(thu12),dlog(thu22)))
       pup = dexp(ff(dlog(pup12),dlog(pup22)))
       pum = dexp(ff(dlog(pum12),dlog(pum22)))
      endif
      write(6,*)amh,sig,'+-',thu,pup,-pum
      if(i135.eq.0)then
       amh = 125.4d0
       if(ilog.eq.0)then
        sig = ff(sig13,sig23)
        thu = ff(thu13,thu23)
        pup = ff(pup13,pup23)
        pum = ff(pum13,pum23)
       else
        sig = dexp(ff(dlog(sig13),dlog(sig23)))
        thu = dexp(ff(dlog(thu13),dlog(thu23)))
        pup = dexp(ff(dlog(pup13),dlog(pup23)))
        pum = dexp(ff(dlog(pum13),dlog(pum23)))
       endif
       write(6,*)amh,sig,'+-',thu,pup,-pum
      endif
      stop
      end

      double precision function ff(x,y)
      implicit double precision (a-h,o-z)
      common/energy/i135
      if(i135.eq.0)then
       ff = 0.4d0*x + 0.6d0*y
      else
       ff = 0.8d0*x + 0.2d0*y
      endif
      return
      end
