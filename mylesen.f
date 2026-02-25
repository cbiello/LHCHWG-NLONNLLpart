      program AAreadit
      implicit double precision (a-h,o-z)
      character*10 aaa
      character(len=30) :: filename
      common/energy/i135
c-- 0 = 13 TeV     1 = 13.5 Tev
      i135 = 0
      ilog = 0
      if(i135.eq.0)then
       write(6,*)'13.0 TeV'
       write(6,*)'========'
       open(95,file='Ecm_13000/BPT_summary4_NLO+NNLLpart+ybyt.dat')
       do i=1,3
        read(95,*)
       enddo
      else
       write(6,*)'13.5 TeV'
       write(6,*)'========'
       open(95,file='Ecm_13500/BPT_summary4_NLO+NNLLpart+ybyt.dat')
       do i=1,3
        read(95,*)
       enddo
       print*, 'not supported'
       stop
      endif
      write(6,*)
      write(6,*)'14.0 TeV'
      write(6,*)'========'
      open(96,file='Ecm_14000/BPT_summary4_NLO+NNLLpart+ybyt.dat')
      do i=1,3
       read(96,*)
      enddo

!     Additional distributions needed for the LHCHWG paper, i.e. 7 GeV, 8 GeV
      write(6,*)
      write(6,*)'7.0 TeV'
      write(6,*)'========'
      open(97,file='Ecm_7000/BPT_summary4_NLO+NNLLpart+ybyt.dat')
      do i=1,3
       read(97,*)
      enddo
      write(6,*)
      write(6,*)'8.0 TeV'
      write(6,*)'========'
      open(98,file='Ecm_8000/BPT_summary4_NLO+NNLLpart+ybyt.dat')
      do i=1,3
       read(98,*)
      enddo
      
      write(filename, '(A,I0,A)') 'saved-136-ilog', ilog, '.dat'
      open(6,file='saved-13.dat')
      open(7,file='saved-14.dat')
      open(8,file=filename)
      open(9,file='saved-7.dat')
      open(10,file='saved-8.dat')
      
      do j=1, 100

!!!!!!!! FORMAT
!     amh = MHIGGS
!     xmuf = useless
!     aaa = useless
!     sig11 = XSECTION
!     rfu = DELTA_MUF+MUR
!     xmu = DELTA_MUB
!     amb = PARAMETRIC M_B UNCERTAINTY
!     pdfp = deltaPDF_up
!     pdfm = deltaPDF_down
!     asm = delta_as_up
!     asp = delta_as_down
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!     Feb24: added the splitted contributions for the sources of
!     theoretical and parametrical uncertainty

!     Lets start with the ones we will not use for the combination
!     7 GeV
      read(97,*)amh,xmuf,aaa,sig7,rfu,xmu,amb,pdfp,pdfm,asm,asp
      thu7 = dsqrt(rfu**2+xmu**2)
      pup7 = dsqrt(amb**2+pdfp**2+asp**2)
      pum7 = dsqrt(amb**2+pdfm**2+asm**2)
      drf7 = rfu
      dmub7 = xmu
      dmass7 = amb
      dpdfp7 = pdfp 
      dpdfm7 = pdfm 
      dasp7 = asp
      dasm7 = asm
      write(9,*)amh,sig7,'+-',drf7,dmub7,thu7,dmass7,-dmass7,
     & dpdfp7,-dpdfm7,dasp7,-dasm7,pup7,-pum7
!     8 GeV
      read(98,*)amh,xmuf,aaa,sig8,rfu,xmu,amb,pdfp,pdfm,asm,asp
      thu8 = dsqrt(rfu**2+xmu**2)
      pup8 = dsqrt(amb**2+pdfp**2+asp**2)
      pum8 = dsqrt(amb**2+pdfm**2+asm**2)
      drf8 = rfu
      dmub8 = xmu
      dmass8 = amb
      dpdfp8 = pdfp
      dpdfm8 = pdfm
      dasp8 = asp
      dasm8 = asm
      write(10,*)amh,sig8,'+-',drf8,dmub8,thu8,dmass8,-dmass8,
     & dpdfp8,-dpdfm8,dasp8,-dasm8,pup8,-pum8

! Now 13, 14 and their interpolation      
      read(95,*)amh,xmuf,aaa,sig11,rfu,xmu,amb,pdfp,pdfm,asm,asp
      thu11 = dsqrt(rfu**2+xmu**2)
      pup11 = dsqrt(amb**2+pdfp**2+asp**2)
      pum11 = dsqrt(amb**2+pdfm**2+asm**2)
      drf11 = rfu
      dmub11 = xmu
      dmass11 = amb
      dpdfp11 = pdfp
      dpdfm11 = pdfm
      dasp11 = asp
      dasm11 = asm
      write(6,*)amh,sig11,'+-',drf11,dmub11,thu11,dmass11,-dmass11,
     & dpdfp11,-dpdfm11,dasp11,-dasm11,pup11,-pum11
      
      read(96,*)amh2,xmuf,aaa,sig21,rfu,xmu,amb,pdfp,pdfm,asm,asp
      thu21 = dsqrt(rfu**2+xmu**2)
      pup21 = dsqrt(amb**2+pdfp**2+asp**2)
      pum21 = dsqrt(amb**2+pdfm**2+asm**2)
      drf21 = rfu
      dmub21 = xmu
      dmass21 = amb
      dpdfp21 = pdfp
      dpdfm21 = pdfm
      dasp21 = asp
      dasm21 = asm
      write(7,*)amh2,sig21,'+-',drf21,dmub21,thu21,dmass21,-dmass21,
     & dpdfp21,-dpdfm21,dasp21,-dasm21,pup21,-pum21

      if(ilog.eq.0)then
       sig = ff(sig11,sig21)
       thu = ff(thu11,thu21)
       pup = ff(pup11,pup21)
       pum = ff(pum11,pum21)
       !new
       drf   = ff(drf11,drf21)
       dmub  = ff(dmub11,dmub21)
       dmass = ff(dmass11,dmass21)
       dpdfp = ff(dpdfp11,dpdfp21)
       dpdfm = ff(dpdfm11,dpdfm21)
       dasp  = ff(dasp11,dasp21)
       dasm  = ff(dasm11,dasm21)       
      else
       sig = dexp(ff(dlog(sig11),dlog(sig21)))
       thu = dexp(ff(dlog(thu11),dlog(thu21)))
       pup = dexp(ff(dlog(pup11),dlog(pup21)))
       pum = dexp(ff(dlog(pum11),dlog(pum21)))
       !new
       drf   = dexp(ff(dlog(drf11),dlog(drf21)))
       dmub  = dexp(ff(dlog(dmub11),dlog(dmub21)))
       dmass = dexp(ff(dlog(dmass11),dlog(dmass21)))
       dpdfp = dexp(ff(dlog(dpdfp11),dlog(dpdfp21)))
       dpdfm = dexp(ff(dlog(dpdfm11),dlog(dpdfm21)))
       dasp  = dexp(ff(dlog(dasp11),dlog(dasp21)))
       dasm  = dexp(ff(dlog(dasm11),dlog(dasm21)))
      endif
      if(amh.eq.amh2) then
         write(8,*)amh,sig,'+-',drf,dmub,thu,dmass,-dmass,dpdfp,-dpdfm,
     &   dasp,-dasm,pup,-pum     
      else
         print*, 'error 2'
         stop
      endif
      
      enddo
      
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
