<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.cont.*, acar.fee.*, acar.util.*, acar.cls.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function printWin(){
		if(window.print){
			window.print();
		}
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_p.css">
</head>
<body>
<%
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String b_dt 	= request.getParameter("b_dt")==null?"":request.getParameter("b_dt");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String bill_yn 	= request.getParameter("bill_yn")==null?"":request.getParameter("bill_yn");
	String cls_chk 	= request.getParameter("cls_chk")==null?"N":request.getParameter("cls_chk");
	String doc_dt 	= request.getParameter("doc_dt1")==null?"":request.getParameter("doc_dt1");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//기본정보
	Hashtable fee = af_db.getFeebaseNew(m_id, l_cd);
	
	//최초대여정보
	ContFeeBean f_fee = a_db.getContFeeNew(m_id, l_cd, "1");
	
	//해지정보
	ClsBean cls = as_db.getClsCase(m_id, l_cd);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(m_id, l_cd)+"";
	}
			
	//출고지연대차
	ContTaechaBean taecha = a_db.getTaecha(m_id, l_cd, taecha_no);
	
	//건별 대여료 스케줄 리스트
	Vector fee_scd = af_db.getFeeScdNew(m_id, l_cd, "0", b_dt, mode, bill_yn);
	int fee_scd_size = fee_scd.size();
	
	int m_scd_size = 0;
	
	int nc = 0;
	int ns = 0;
	int nv = 0;
	int rc = 0;
	int rs = 0;
	int rv = 0;
	int mc = 0;
	int ms = 0;
	int mv = 0;
	int dc = 0;
	int dt = 0;
	int dt2 = 0;
	
	//건별 대여료 스케줄 통계
	Hashtable fee_stat = af_db.getFeeScdStatNew(m_id, l_cd, b_dt, mode, bill_yn);
	int fee_stat_size = fee_stat.size();
%>
<form name='form1' action='' method='post' target=''>
<input type='hidden' name='cls_chk' value='<%=cls_chk%>'>
<input type='hidden' name='bill_yn' value='<%=bill_yn%>'>
<input type='hidden' name='b_dt' value='<%=b_dt%>'>
  <!-- <table border="0" cellspacing="0" cellpadding="0" width=645> -->
  <table border="0" cellspacing="0" cellpadding="0" width=720>
    <tr>
	  <td>
	    <!-- <table width="645"> -->
	    <table width="720">
          <tr>
            <td width="400"> <font color="red"> 대여료 스케줄 조회 및 수금 </font> </td>
            <td align="right"><a href="javascript:printWin()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_print.gif"  align="absmiddle" border="0"></a> 
            </td>		  
		  </tr>		
	    </table>  
	  </td> 
    </tr>
    <tr> 
      <td colspan="2"> 
        <!-- <table border="0" cellspacing="1" cellpadding="0" width=645> -->
        <table border="0" cellspacing="1" cellpadding="0" width=720>
          <tr> 
            <td class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                  <td width='10%' class='title' style="font-size : 8pt;">계약번호</td>
                  <td width='15%'>&nbsp;<%=fee.get("RENT_L_CD")%></td>
                  <td width='10%' class='title' style="font-size : 8pt;">상호</td>
                  <td>&nbsp;<%=fee.get("FIRM_NM")%></td>
                  <td width='10%' class='title' style="font-size : 8pt;">고객명</td>
                  <td width='15%'>&nbsp;<%=fee.get("CLIENT_NM")%></td>
                </tr>
                <tr> 
                  <td class='title' style="font-size : 8pt;">차량번호</td>
                  <td>&nbsp;<font color="#000099"><b><%=fee.get("CAR_NO")%></b></font></td>
                  <td class='title' style="font-size : 8pt;">차명</td>
                  <td>&nbsp;<%=fee.get("CAR_NM")%></td>
                  <td class='title' style="font-size : 8pt;">대여방식</td>
                  <td>&nbsp;<%if(fee.get("RENT_WAY").equals("1")){%>
                    일반식 
                    <%}else if(fee.get("RENT_WAY").equals("2")){%>
                    맞춤식 
                    <%}else{%>
                    기본식 
                    <%}%></td>
                </tr>
              </table>
            </td>
          </tr>
    	</table>
	  </td>
  	</tr>	
  </table>
  <%if(fee_scd_size>0){//출고지연대차%>  
<!--   <table border="0" cellspacing="0" cellpadding="0" width=645>	 -->
  <table border="0" cellspacing="0" cellpadding="0" width=720>	
    <tr> 
      <td width="400">&lt;&lt; 출고지연대차 &gt;&gt;</td>
      <td align='right' width="400">&nbsp;</td>
    </tr>  
    <tr> 
      <td colspan="2"> 
        <!-- <table border="0" cellspacing="1" cellpadding="0" width=645> -->
        <table border="0" cellspacing="1" cellpadding="0" width=720>
          <tr> 
            <td class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width=100%>				
                <tr> 
                  <td width='10%' class='title' style="font-size : 8pt;">차량번호</td>
                  <td width='40%' >&nbsp;<%=taecha.getCar_no()%></td>
                  <td width='10%' class='title' style="font-size : 8pt;">차명</td>
                  <td width='40%' >&nbsp;<%=c_db.getNameById(taecha.getCar_id(), "FULL_CAR_NM")%></td>
                </tr>
                <tr> 
                  <td class='title' style="font-size : 8pt;"> 대여기간 </td>
                  <td>&nbsp;<%=taecha.getCar_rent_st()%>~<%=taecha.getCar_rent_et()%></td>
                  <td class='title' style="font-size : 8pt;"> 월대여료 </td>
                  <td>&nbsp;<%=AddUtil.parseDecimal(taecha.getRent_fee())%>원&nbsp;</td>
                </tr>		
              </table>		
            </td>
          </tr>
    	</table>
	  </td>
  	</tr>	
  </table>
  <!-- <table border="0" cellspacing="0" cellpadding="0" width=645> -->
  <table border="0" cellspacing="0" cellpadding="0" width=720>
    <tr> 
      <td class=line colspan='2'> 
        <!-- <table border="0" cellspacing="1" cellpadding="0" width="645"> -->
        <table border="0" cellspacing="1" cellpadding="0" width="720">
          <tr> 
            <!--<td style="font-size : 8pt;" class='title' width="20">연<br>번</td>-->
            <td style="font-size : 8pt;" class='title' width="40">회<br>차</td>			
            <td style="font-size : 8pt;" class='title' width="40">구분</td>
            <td style="font-size : 8pt;" class='title' width="110">사용기간</td>
            <td style="font-size : 8pt;" class='title' width="60">입금예정일</td>			
            <td style="font-size : 8pt;" class='title' width="60">공급가</td>
            <td style="font-size : 8pt;" class='title' width="55">부가세</td>
            <td style="font-size : 8pt;" class='title' width="65">월대여료</td>
            <td style="font-size : 8pt;" class='title' width="60">입금일자</td>
            <td style="font-size : 8pt;" class='title' width="70">실입금액</td>
            <td style="font-size : 8pt;" class='title' width="40">연체<br>일수</td>
            <td style="font-size : 8pt;" class='title' width="45">연체료</td>
            <td style="font-size : 8pt;" class='title' width="75">세금계산서<br>발행</td>
          </tr>
          <%for(int i = 0 ; i < fee_scd_size ; i++){
				FeeScdBean a_fee = (FeeScdBean)fee_scd.elementAt(i);
				if(cls_chk.equals("Y") && !a_fee.getTm_st1().equals("0") && a_fee.getBill_yn().equals("N")) continue;
				//대여료통계
				if(a_fee.getRc_amt()>0){//수금
					rc ++;
					rs += Math.round(a_fee.getRc_amt()/1.1);
					rv += a_fee.getRc_amt()-(Math.round(a_fee.getRc_amt()/1.1));
				}else{
					if(a_fee.getDly_fee()==0){//미도래
						mc ++;
						ms += a_fee.getFee_s_amt();
						mv += a_fee.getFee_v_amt();
					}else{
						nc ++;
						ns += a_fee.getFee_s_amt();
						nv += a_fee.getFee_v_amt();
					}
				}
				//연체료통계
				if(a_fee.getDly_fee()>0){
					dc ++;
					dt += a_fee.getDly_fee();
				}
				
				if(a_fee.getTm_st1().equals("0")){
					m_scd_size++;
				}
				
				if(a_fee.getBill_yn().equals("Y") || a_fee.getRc_amt() >0){
				
				%>
          <tr> 
            <!--<td style="font-size : 8pt;" align='center'><%=i+1%></td>-->
            <td style="font-size : 8pt;" align='center'><%=m_scd_size%><%//=AddUtil.parseInt(a_fee.getFee_tm())-m_scd_size%></td>			
            <td style="font-size : 8pt;" align='center'><%if(a_fee.getTm_st1().equals("0")){%>대여료<%}else{%>잔액<%}%></td>
            <td style="font-size : 8pt;" align='center'><%=a_fee.getUse_s_dt()%>~<%=a_fee.getUse_e_dt()%></td>
            <td style="font-size : 8pt;" align='center'><%=a_fee.getFee_est_dt()%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_s_amt())%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_v_amt())%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_s_amt()+a_fee.getFee_v_amt())%></td>
			<%		if( cls_chk.equals("Y") && a_fee.getRc_dt().equals(AddUtil.replace(cls.getCls_dt(),"-","")) ){%>
            <td style="font-size : 8pt;" align='center'><input type='text' name='pay_dt' size='8' class='whitenum_8size' value=''></td>
            <td style="font-size : 8pt;" align='center'><input type='text' name='pay_amt' size='9' class='whitenum_8size' value='0'></td>
            <td style="font-size : 8pt;" align='center'><input type='text' name='dly_dt' size='3' class='whitenum_8size'  value='<%=a_fee.getDly_days()%>'>
            	<%if((a_fee.getRc_dt().equals("") || AddUtil.parseInt(a_fee.getRc_dt())<AddUtil.parseInt(doc_dt)) && a_fee.getRc_amt()==0){ %>
	           	<br><span style="font-size: 10px; letter-spacing: -1.5px;">연체 해지</span>
				<%}%>
            </td>
            <td style="font-size : 8pt;" align='center'><input type='text' name='dly_amt' size='6' class='whitenum_8size' value='<%=Util.parseDecimal(a_fee.getDly_fee())%>'></td>
            <td style="font-size : 8pt;" align='center'><%=AddUtil.ChangeDate2(a_fee.getExt_dt())%></td>
			<%		}else{%>
            <td style="font-size : 8pt;" align='center'><input type='text' name='pay_dt' size='8' class='whitenum_8size' value='<%=a_fee.getRc_dt()%>'></td>
            <td style="font-size : 8pt;" align='center'><input type='text' name='pay_amt' size='9' class='whitenum_8size' value='<%=Util.parseDecimal(a_fee.getRc_amt())%>'></td>
            <td style="font-size : 8pt;" align='center'><input type='text' name='dly_dt' size='3' class='whitenum_8size'  value='<%=a_fee.getDly_days()%>'>
            	<%if((a_fee.getRc_dt().equals("") || AddUtil.parseInt(a_fee.getRc_dt())<AddUtil.parseInt(doc_dt)) && a_fee.getRc_amt()==0){ %>
	           	<br><span style="font-size: 10px; letter-spacing: -1.5px;">연체 해지</span>
				<%}%>
            </td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getDly_fee())%><input type='hidden' name='dly_amt' size='0' class='whitenum_8size' value=''></td>
            <td style="font-size : 8pt;" align='center'><%=AddUtil.ChangeDate2(a_fee.getExt_dt())%></td>			
			<%		}%>
          </tr>
		  <%	}else{%>
          <tr> 
            <!--<td style="font-size : 8pt;" align='center'><%=i+1%></td>-->
            <td style="font-size : 8pt;" align='center'><%=m_scd_size%><%//=AddUtil.parseInt(a_fee.getFee_tm())-m_scd_size%></td>
            <td style="font-size : 8pt;" align='center'><%if(a_fee.getTm_st1().equals("0")){%>대여료<%}else{%>잔액<%}%></td>
            <td style="font-size : 8pt;" align='center'><%=a_fee.getUse_s_dt()%>~<%=a_fee.getUse_e_dt()%></td>
            <td style="font-size : 8pt;" align='center'><%=a_fee.getFee_est_dt()%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_s_amt())%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_v_amt())%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_s_amt()+a_fee.getFee_v_amt())%></td>
            <td style="font-size : 8pt;" align='center'><input type='text' name='pay_dt' size='8' class='whitenum_8size' value='<%if(cls_chk.equals("Y")){%><%}else{%><%=AddUtil.replace(cls.getCls_dt(),"-","")%><%}%>'></td>
            <td style="font-size : 8pt;" align='center'><input type='text' name='pay_amt' size='9' class='whitenum_8size' value='<%if(cls_chk.equals("Y")){%>0<%}else{%>중도해지정산<%}%>'></td>
            <td style="font-size : 8pt;" align='center'><input type='text' name='dly_dt' size='3' class='whitenum_8size'  value='<%=a_fee.getDly_days()%>'>
            	<%if((a_fee.getRc_dt().equals("") || AddUtil.parseInt(a_fee.getRc_dt())<AddUtil.parseInt(doc_dt)) && a_fee.getRc_amt()==0){ %>
	           	<br><span style="font-size: 10px; letter-spacing: -1.5px;">연체 해지</span>
				<%}%>
            </td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getDly_fee())%><input type='hidden' name='dly_amt' size='0' class='whitenum_8size' value=''></td>
            <td style="font-size : 8pt;" align='center'><%=AddUtil.ChangeDate2(a_fee.getExt_dt())%></td>
          </tr>		  
		  <%	}%>
          <%}%>
        </table>
      </td>
      <td width='20'>&nbsp;</td>
    </tr>
  </table>  
  <%	m_scd_size = 0;%>
  <%}%>		  
  <!-- <table border="0" cellspacing="0" cellpadding="0" width=645> -->
  <table border="0" cellspacing="0" cellpadding="0" width=720>
    <tr> 
      <td width="400">&lt;&lt; 신차대여 &gt;&gt;</td>
      <td align='right' width="400">&nbsp;</td>
    </tr>  
    <tr> 
      <td colspan="2"> 
        <!-- <table border="0" cellspacing="1" cellpadding="0" width=645> -->
        <table border="0" cellspacing="1" cellpadding="0" width=720>
          <tr> 
            <td class='line'> 			  					  	
              <table border="0" cellspacing="1" cellpadding="0" width=100%>				
                <tr> 
                  <td width='10%' class='title' style="font-size : 8pt;">채권유형</td>
                  <td width='15%' >&nbsp;<%=fee.get("GI_ST")%></td>
                  <td width='10%' class='title' style="font-size : 8pt;">대여기간</td>
                  <td width='15%' >&nbsp;<%=f_fee.getCon_mon()%>개월</td>
                  <td width='10%' class='title' style="font-size : 8pt;">개시일</td>
                  <td width='15%'>&nbsp;<%=AddUtil.ChangeDate2(f_fee.getRent_start_dt())%></td>
                  <td width='10%' class='title' style="font-size : 8pt;">만료일</td>
                  <td width='15%'>&nbsp;<%=AddUtil.ChangeDate2(f_fee.getRent_end_dt())%></td>
                </tr>
                <tr> 
                  <td class='title' style="font-size : 8pt;"> 선납금 </td>
                  <td>&nbsp;<%=Util.parseDecimal(f_fee.getPp_s_amt()+f_fee.getPp_v_amt())%>원</td>
                  <td class='title' style="font-size : 8pt;"> 보증금 </td>
                  <td>&nbsp;<%=Util.parseDecimal(f_fee.getGrt_amt_s())%>원&nbsp;</td>
                  <td class='title' style="font-size : 8pt;">개시대여료</td>
                  <td>&nbsp;<%=Util.parseDecimal(f_fee.getIfee_s_amt()+f_fee.getIfee_v_amt())%>원<%if(f_fee.getIfee_s_amt() >0){%><span style="font-size : 8pt;">(<%=f_fee.getIfee_s_amt()/f_fee.getFee_s_amt()%>회)</span><%}%>
				  </td>
                  <td class='title' style="font-size : 8pt;">월대여료</td>
                  <td>&nbsp;<%=Util.parseDecimal(f_fee.getFee_s_amt()+f_fee.getFee_v_amt())%>원</td>
                </tr>	
              </table>		
            </td>
          </tr>
    	</table>
	  </td>
  	</tr>	
  </table>			
  <%	//건별 대여료 스케줄 리스트
		fee_scd = af_db.getFeeScdNew(m_id, l_cd, "1", b_dt, mode, bill_yn);
		fee_scd_size = fee_scd.size();
  %>
  <!-- <table border="0" cellspacing="0" cellpadding="0" width=645> -->
  <table border="0" cellspacing="0" cellpadding="0" width=720>
    <tr> 
      <td class=line colspan='2'> 
        <!-- <table border="0" cellspacing="1" cellpadding="0" width="645"> -->
        <table border="0" cellspacing="1" cellpadding="0" width="720">
          <tr> 
            <!--<td style="font-size : 8pt;" class='title' width="20">연<br>번</td>-->
            <td style="font-size : 8pt;" class='title' width="40">회<br>차</td>			
            <td style="font-size : 8pt;" class='title' width="40">구분</td>
            <td style="font-size : 8pt;" class='title' width="110">사용기간</td>
            <td style="font-size : 8pt;" class='title' width="60">입금예정일</td>			
            <td style="font-size : 8pt;" class='title' width="60">공급가</td>
            <td style="font-size : 8pt;" class='title' width="55">부가세</td>
            <td style="font-size : 8pt;" class='title' width="65">월대여료</td>
            <td style="font-size : 8pt;" class='title' width="60">입금일자</td>
            <td style="font-size : 8pt;" class='title' width="70">실입금액</td>
            <td style="font-size : 8pt;" class='title' width="40">연체<br>일수</td>
            <td style="font-size : 8pt;" class='title' width="45">연체료</td>
            <td style="font-size : 8pt;" class='title' width="75">세금계산서<br>발행일자</td>
          </tr>
          <%for(int i = 0 ; i < fee_scd_size ; i++){
				FeeScdBean a_fee = (FeeScdBean)fee_scd.elementAt(i);
				if(cls_chk.equals("Y") && !a_fee.getTm_st1().equals("0") && a_fee.getBill_yn().equals("N")) continue;
				//대여료통계
				if(a_fee.getRc_amt()>0){//수금
					rc ++;
					rs += Math.round(a_fee.getRc_amt()/1.1);
					rv += a_fee.getRc_amt()-(Math.round(a_fee.getRc_amt()/1.1));
				}else{
					if(a_fee.getDly_fee()==0){//미도래
						mc ++;
						ms += a_fee.getFee_s_amt();
						mv += a_fee.getFee_v_amt();
					}else{
						nc ++;
						ns += a_fee.getFee_s_amt();
						nv += a_fee.getFee_v_amt();
					}
				}
				//연체료통계
				if(a_fee.getDly_fee()>0){
					dc ++;
					dt += a_fee.getDly_fee();
				}
				
				if(a_fee.getTm_st1().equals("0")){
					m_scd_size++;
				}
				
				if(a_fee.getBill_yn().equals("Y") || a_fee.getRc_amt() >0){%>
          <tr> 
            <!--<td style="font-size : 8pt;" align='center'><%=i+1%></td>-->
            <td style="font-size : 8pt;" align='center'><%=m_scd_size%><%//=AddUtil.parseInt(a_fee.getFee_tm())-m_scd_size%></td>
            <td style="font-size : 8pt;" align='center'><%if(a_fee.getTm_st1().equals("0")){%>대여료<%}else{%>잔액<%}%></td>
            <td style="font-size : 8pt;" align='center'><%=a_fee.getUse_s_dt()%>~<%=a_fee.getUse_e_dt()%></td>
            <td style="font-size : 8pt;" align='center'><%=a_fee.getFee_est_dt()%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_s_amt())%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_v_amt())%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_s_amt()+a_fee.getFee_v_amt())%></td>
			<%		if( cls_chk.equals("Y") && a_fee.getRc_dt().equals(AddUtil.replace(cls.getCls_dt(),"-","")) ){%>
            <td style="font-size : 8pt;" align='center'><input type='text' name='pay_dt' size='8' class='whitenum_8size' value=''></td>
            <td style="font-size : 8pt;" align='center'><input type='text' name='pay_amt' size='9' class='whitenum_8size' value='0'></td>
            <td style="font-size : 8pt;" align='center'><input type='text' name='dly_dt' size='3' class='whitenum_8size'  value='<%=a_fee.getDly_days()%>'>
            	<%if((a_fee.getRc_dt().equals("") || AddUtil.parseInt(a_fee.getRc_dt())<AddUtil.parseInt(doc_dt)) && a_fee.getRc_amt()==0){ %>
	           	<br><span style="font-size: 10px; letter-spacing: -1.5px;">연체 해지</span>
				<%}%>
            </td>
            <td style="font-size : 8pt;" align='center'><input type='text' name='dly_amt' size='6' class='whitenum_8size' value='<%=Util.parseDecimal(a_fee.getDly_fee())%>'></td>
            <td style="font-size : 8pt;" align='center'><%=AddUtil.ChangeDate2(a_fee.getExt_dt())%></td>
			<%		}else{%>
            <td style="font-size : 8pt;" align='center'><input type='text' name='pay_dt' size='8' class='whitenum_8size' value='<%=a_fee.getRc_dt()%>'></td>
            <td style="font-size : 8pt;" align='center'><input type='text' name='pay_amt' size='9' class='whitenum_8size' value='<%=Util.parseDecimal(a_fee.getRc_amt())%>'></td>
           	<td style="font-size : 8pt;" align='center'><input type='text' name='dly_dt' size='3' class='whitenum_8size'  value='<%=a_fee.getDly_days()%>'>
	           	<%if((a_fee.getRc_dt().equals("") || AddUtil.parseInt(a_fee.getRc_dt())<AddUtil.parseInt(doc_dt)) && a_fee.getRc_amt()==0){ %>
	           	<br><span style="font-size: 10px; letter-spacing: -1.5px;">연체 해지</span>
				<%}%>
           	</td>
				<%	}%>
	            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getDly_fee())%><input type='hidden' name='dly_amt' size='0' class='whitenum_8size' value=''></td>
	            <td style="font-size : 8pt;" align='center'><%=AddUtil.ChangeDate2(a_fee.getExt_dt())%></td>
          </tr>
		  <%	}else{%>
          <tr> 
            <!--<td style="font-size : 8pt;" align='center'><%=i+1%></td>-->
            <td style="font-size : 8pt;" align='center'><%=m_scd_size%><%//=AddUtil.parseInt(a_fee.getFee_tm())-m_scd_size%></td>
            <td style="font-size : 8pt;" align='center'><%if(a_fee.getTm_st1().equals("0")){%>대여료<%}else{%>잔액<%}%></td>
            <td style="font-size : 8pt;" align='center'><%=a_fee.getUse_s_dt()%>~<%=a_fee.getUse_e_dt()%></td>
            <td style="font-size : 8pt;" align='center'><%=a_fee.getFee_est_dt()%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_s_amt())%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_v_amt())%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_s_amt()+a_fee.getFee_v_amt())%></td>
            <td style="font-size : 8pt;" align='center'><input type='text' name='pay_dt' size='8' class='whitenum_8size' value='<%if(cls_chk.equals("Y")){%><%}else{%><%=AddUtil.replace(cls.getCls_dt(),"-","")%><%}%>'></td>
            <td style="font-size : 8pt;" align='center'><input type='text' name='pay_amt' size='9' class='whitenum_8size' value='<%if(cls_chk.equals("Y")){%>0<%}else{%>중도해지정산<%}%>'></td>
            <td style="font-size : 8pt;" align='center'><input type='text' name='dly_dt' size='3' class='whitenum_8size'  value='<%=a_fee.getDly_days()%>'>
            	<%if((a_fee.getRc_dt().equals("") || AddUtil.parseInt(a_fee.getRc_dt())<AddUtil.parseInt(doc_dt)) && a_fee.getRc_amt()==0){ %>
	           	<br><span style="font-size: 10px; letter-spacing: -1.5px;">연체 해지</span>
				<%}%>
            </td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getDly_fee())%><input type='hidden' name='dly_amt' size='0' class='whitenum_8size' value=''></td>
            <td style="font-size : 8pt;" align='center'><%=AddUtil.ChangeDate2(a_fee.getExt_dt())%></td>
          </tr>		  
		  <%	}%>
          <%}%>
        </table>
      </td>
      <td width='20'>&nbsp;</td>
    </tr>
  </table>   
<%	m_scd_size = 0;%>  				
<%	String rent_st = String.valueOf(fee.get("RENT_ST"));
	for(int j=2; j<=AddUtil.parseInt(rent_st); j++){
		ContFeeBean ext_fee = a_db.getContFeeNew(m_id, l_cd, Integer.toString(j));
		if(!ext_fee.getCon_mon().equals("")){%>		
  <!-- <table border="0" cellspacing="0" cellpadding="0" width=645> -->
  <table border="0" cellspacing="0" cellpadding="0" width=720>
    <tr> 
      <td width="400">&lt;&lt; 연장대여 &gt;&gt;</td>
      <td align='right' width="400">&nbsp;</td>
    </tr>  
    <tr> 
      <td colspan="2"> 
        <!-- <table border="0" cellspacing="1" cellpadding="0" width=645> -->
        <table border="0" cellspacing="1" cellpadding="0" width=720>
          <tr> 
            <td class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width=100%>									
                <tr> 
                  <td width='10%' class='title' style="font-size : 8pt;">연장계약일</td>
                  <td width='15%'>&nbsp;<%=AddUtil.ChangeDate2(ext_fee.getRent_dt())%></td>
                  <td width='10%' class='title' style="font-size : 8pt;">대여기간</td>
                  <td width='15%'>&nbsp;<%=ext_fee.getCon_mon()%>개월</td>
                  <td width='10%' class='title' style="font-size : 8pt;">개시일</td>
                  <td width='15%'>&nbsp;<%=AddUtil.ChangeDate2(ext_fee.getRent_start_dt())%></td>
                  <td width='10%' class='title' style="font-size : 8pt;">만료일</td>
                  <td width='15%'>&nbsp;<%=AddUtil.ChangeDate2(ext_fee.getRent_end_dt())%></td>
                </tr>
                <tr> 
                  <td class='title' style="font-size : 8pt;">선납금</td>
               	  <td>&nbsp;<%=Util.parseDecimal(ext_fee.getPp_s_amt()+ext_fee.getPp_v_amt())%>원&nbsp;&nbsp;</td>
                  <td class='title' style="font-size : 8pt;">보증금</td>
                  <td>&nbsp;<%=Util.parseDecimal(ext_fee.getGrt_amt_s())%>원&nbsp;&nbsp;</td>
                  <td class='title' style="font-size : 8pt;">개시대여료</td>
                  <td>&nbsp;<%=Util.parseDecimal(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())%>원<%if(ext_fee.getIfee_s_amt() >0){%><span style="font-size : 8pt;">(<%=ext_fee.getIfee_s_amt()/ext_fee.getFee_s_amt()%>회)</span><%}%>
				  </td>
                  <td class='title' style="font-size : 8pt;">월대여료</td>
                  <td>&nbsp;<%=Util.parseDecimal(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt())%>원&nbsp;</td>
                </tr>
              </table>
            </td>
          </tr>
    	</table>
	  </td>
  	</tr>
  </table>
  <%	//건별 대여료 스케줄 리스트
		fee_scd = af_db.getFeeScdNew(m_id, l_cd, Integer.toString(j), b_dt, mode, bill_yn);
		fee_scd_size = fee_scd.size();
  %>
  <!-- <table border="0" cellspacing="0" cellpadding="0" width=645> -->
  <table border="0" cellspacing="0" cellpadding="0" width=720>
    <tr> 
      <td class=line colspan='2'> 
        <!-- <table border="0" cellspacing="1" cellpadding="0" width="645"> -->
        <table border="0" cellspacing="1" cellpadding="0" width="720">
          <tr> 
            <!--<td style="font-size : 8pt;" class='title' width="20">연<br>번</td>-->
            <td style="font-size : 8pt;" class='title' width="40">회<br>차</td>			
            <td style="font-size : 8pt;" class='title' width="40">구분</td>
            <td style="font-size : 8pt;" class='title' width="110">사용기간</td>
            <td style="font-size : 8pt;" class='title' width="60">입금예정일</td>			
            <td style="font-size : 8pt;" class='title' width="60">공급가</td>
            <td style="font-size : 8pt;" class='title' width="55">부가세</td>
            <td style="font-size : 8pt;" class='title' width="65">월대여료</td>
            <td style="font-size : 8pt;" class='title' width="60">입금일자</td>
            <td style="font-size : 8pt;" class='title' width="70">실입금액</td>
            <td style="font-size : 8pt;" class='title' width="40">연체<br>일수</td>
            <td style="font-size : 8pt;" class='title' width="45">연체료</td>
            <td style="font-size : 8pt;" class='title' width="75">세금계산서<br>발행일자</td>
          </tr>
          <%for(int i = 0 ; i < fee_scd_size ; i++){
				FeeScdBean a_fee = (FeeScdBean)fee_scd.elementAt(i);
				if(cls_chk.equals("Y") && !a_fee.getTm_st1().equals("0") && a_fee.getBill_yn().equals("N")) continue;
				//대여료통계
				if(a_fee.getRc_amt()>0){//수금
					rc ++;
					rs += Math.round(a_fee.getRc_amt()/1.1);
					rv += a_fee.getRc_amt()-(Math.round(a_fee.getRc_amt()/1.1));
				}else{
					if(a_fee.getDly_fee()==0){//미도래
						mc ++;
						ms += a_fee.getFee_s_amt();
						mv += a_fee.getFee_v_amt();
					}else{
						nc ++;
						ns += a_fee.getFee_s_amt();
						nv += a_fee.getFee_v_amt();
					}
				}
				//연체료통계
				if(a_fee.getDly_fee()>0){
					dc ++;
					dt += a_fee.getDly_fee();
				}
				
				if(a_fee.getTm_st1().equals("0")){
					m_scd_size++;
				}
				
				if(a_fee.getBill_yn().equals("Y") || a_fee.getRc_amt() >0){%>
          <tr> 
            <!--<td style="font-size : 8pt;" align='center'><%=i+1%></td>-->
            <td style="font-size : 8pt;" align='center'><%=m_scd_size%><%//=AddUtil.parseInt(a_fee.getFee_tm())-m_scd_size%></td>
            <td style="font-size : 8pt;" align='center'><%if(a_fee.getTm_st1().equals("0")){%>대여료<%}else{%>잔액<%}%></td>
            <td style="font-size : 8pt;" align='center'><%=a_fee.getUse_s_dt()%>~<%=a_fee.getUse_e_dt()%></td>
            <td style="font-size : 8pt;" align='center'><%=a_fee.getFee_est_dt()%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_s_amt())%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_v_amt())%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_s_amt()+a_fee.getFee_v_amt())%></td>
			<%		if( cls_chk.equals("Y") && a_fee.getRc_dt().equals(AddUtil.replace(cls.getCls_dt(),"-","")) ){%>
            <td style="font-size : 8pt;" align='center'><input type='text' name='pay_dt' size='8' class='whitenum_8size' value=''></td>
            <td style="font-size : 8pt;" align='center'><input type='text' name='pay_amt' size='9' class='whitenum_8size' value='0'></td>
            <td style="font-size : 8pt;" align='center'><input type='text' name='dly_dt' size='3' class='whitenum_8size'  value='<%=a_fee.getDly_days()%>'>
            	<%if((a_fee.getRc_dt().equals("") || AddUtil.parseInt(a_fee.getRc_dt())<AddUtil.parseInt(doc_dt)) && a_fee.getRc_amt()==0){ %>
	           	<br><span style="font-size: 10px; letter-spacing: -1.5px;">연체 해지</span>
				<%}%>
            </td>
            <td style="font-size : 8pt;" align='center'><input type='text' name='dly_amt' size='6' class='whitenum_8size' value='<%=Util.parseDecimal(a_fee.getDly_fee())%>'></td>
            <td style="font-size : 8pt;" align='center'><%=AddUtil.ChangeDate2(a_fee.getExt_dt())%></td>
			<%		}else{%>
            <td style="font-size : 8pt;" align='center'><input type='text' name='pay_dt' size='8' class='whitenum_8size' value='<%=a_fee.getRc_dt()%>'></td>
            <td style="font-size : 8pt;" align='center'><input type='text' name='pay_amt' size='9' class='whitenum_8size' value='<%=Util.parseDecimal(a_fee.getRc_amt())%>'></td>
            <td style="font-size : 8pt;" align='center'><input type='text' name='dly_dt' size='3' class='whitenum_8size'  value='<%=a_fee.getDly_days()%>'>
            	<%if((a_fee.getRc_dt().equals("") || AddUtil.parseInt(a_fee.getRc_dt())<AddUtil.parseInt(doc_dt)) && a_fee.getRc_amt()==0){ %>
	           	<br><span style="font-size: 10px; letter-spacing: -1.5px;">연체 해지</span>
				<%}%>
            </td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getDly_fee())%><input type='hidden' name='dly_amt' size='0' class='whitenum_8size' value=''></td>
            <td style="font-size : 8pt;" align='center'><%=AddUtil.ChangeDate2(a_fee.getExt_dt())%></td>			
			<%		}%>
          </tr>
		  <%	}else{%>
          <tr> 
            <!--<td style="font-size : 8pt;" align='center'><%=i+1%></td>-->
            <td style="font-size : 8pt;" align='center'><%=m_scd_size%><%//=AddUtil.parseInt(a_fee.getFee_tm())-m_scd_size%></td>
            <td style="font-size : 8pt;" align='center'><%if(a_fee.getTm_st1().equals("0")){%>대여료<%}else{%>잔액<%}%></td>
            <td style="font-size : 8pt;" align='center'><%=a_fee.getUse_s_dt()%>~<%=a_fee.getUse_e_dt()%></td>
            <td style="font-size : 8pt;" align='center'><%=a_fee.getFee_est_dt()%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_s_amt())%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_v_amt())%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_s_amt()+a_fee.getFee_v_amt())%></td>
            <td style="font-size : 8pt;" align='center'><input type='text' name='pay_dt' size='8' class='whitenum_8size' value='<%if(cls_chk.equals("Y")){%><%}else{%><%=AddUtil.replace(cls.getCls_dt(),"-","")%><%}%>'></td>
            <td style="font-size : 8pt;" align='center'><input type='text' name='pay_amt' size='9' class='whitenum_8size' value='<%if(cls_chk.equals("Y")){%>0<%}else{%>중도해지정산<%}%>'></td>
            <td style="font-size : 8pt;" align='center'><input type='text' name='dly_dt' size='3' class='whitenum_8size'  value='<%=a_fee.getDly_days()%>'>
            	<%if((a_fee.getRc_dt().equals("") || AddUtil.parseInt(a_fee.getRc_dt())<AddUtil.parseInt(doc_dt)) && a_fee.getRc_amt()==0){ %>
	           	<br><span style="font-size: 10px; letter-spacing: -1.5px;">연체 해지</span>
				<%}%>
            </td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getDly_fee())%><input type='hidden' name='dly_amt' size='0' class='whitenum_8size' value=''></td>
            <td style="font-size : 8pt;" align='center'><%=AddUtil.ChangeDate2(a_fee.getExt_dt())%></td>
          </tr>		  
		  <%	}%>
          <%}%>
        </table>
      </td>
      <td width='20'>&nbsp;</td>
    </tr>
  </table>     
  <%	}
	}%>  

  <%if(fee_stat_size > 0){%>
  <!-- <table border="0" cellspacing="0" cellpadding="0" width=645> -->
  <table border="0" cellspacing="0" cellpadding="0" width=720>
    <tr>
	  <td align='left'>&lt;&lt; 수금 현황 &gt;&gt;</td>
	</tr>
	<tr>
	  <td>
		<!-- <table width='645'> -->
		<table width='720'>
          <tr>
			<td>
			  <table border="0" cellspacing="0" cellpadding="0" width=400>
                <tr>
				  <td class='line'>
					<table border="0" cellspacing="1" cellpadding="0" width=400>
                      <tr>
						<td class='title' width='60'>구분</td>
						<td class='title' width='50'>건수</td>
						<td class='title' width='100'>공급가</td>
						<td class='title' width='90'>부가세</td>
						<td class='title' width='100'>합계</td>
					  </tr>
					  <tr>
						<td class='title'> 미수금 </td>
						<td style="font-size : 8pt;" align='center'>
						  <input type='text' name='s_c' value='<%=Util.parseDecimal(nc)%>' size='3' class='whitenum_8size' >건</td>
						<td style="font-size : 8pt;" align='center'>
						  <input type='text' name='s_s' value='<%=Util.parseDecimal(ns)%>' size='10' class='whitenum_8size' >원</td>
						<td style="font-size : 8pt;" align='center'>
						  <input type='text' name='s_v' value='<%=Util.parseDecimal(nv)%>' size='10' class='whitenum_8size' >원</td>
						<td style="font-size : 8pt;" align='center'>
						  <input type='text' name='s_n' value='<%=Util.parseDecimal(ns+nv)%>' size='10' class='whitenum_8size' >원</td>
					  </tr>
					  <tr>
					    <td class='title'> 수금 </td>
						<td style="font-size : 8pt;" align='center'>
						  <input type='text' name='s_c' value='<%=Util.parseDecimal(rc)%>' size='3' class='whitenum_8size' >건</td>
						<td style="font-size : 8pt;" align='center'>
						  <input type='text' name='s_s' value='<%=Util.parseDecimal(rs)%>' size='10' class='whitenum_8size' >원</td>
						<td style="font-size : 8pt;" align='center'>
						  <input type='text' name='s_v' value='<%=Util.parseDecimal(rv)%>' size='10' class='whitenum_8size' >원</td>
						<td style="font-size : 8pt;" align='center'>
						  <input type='text' name='s_n' value='<%=Util.parseDecimal(rs+rv)%>' size='10' class='whitenum_8size' >원</td>
					  </tr>
					  <tr>
						<td class='title'> 미도래금 </td>
						<td style="font-size : 8pt;" align='center'>
						  <input type='text' name='s_c' value='<%=Util.parseDecimal(mc)%>' size='3' class='whitenum_8size' >건</td>
						<td style="font-size : 8pt;" align='center'>
						  <input type='text' name='s_s' value='<%=Util.parseDecimal(ms)%>' size='10' class='whitenum_8size' >원</td>
						<td style="font-size : 8pt;" align='center'>
						  <input type='text' name='s_v' value='<%=Util.parseDecimal(mv)%>' size='10' class='whitenum_8size' >원</td>
						<td style="font-size : 8pt;" align='center'>
						  <input type='text' name='s_n' value='<%=Util.parseDecimal(ms+mv)%>' size='10' class='whitenum_8size' >원</td>
					  </tr>										
					  <tr>
						<td class='title'> 합계 </td>
						<td style="font-size : 8pt;" align='center'>
						  <input type='text' name='t_c' value='' size='3' class='whitenum_8size' >건</td>
						<td style="font-size : 8pt;" align='center'>
						  <input type='text' name='t_s' value='' size='10' class='whitenum_8size' >원</td>
						<td style="font-size : 8pt;" align='center'>
						  <input type='text' name='t_v' value='' size='10' class='whitenum_8size' >원</td>
						<td style="font-size : 8pt;" align='center'>
						  <input type='text' name='t_n' value='' size='10' class='whitenum_8size' >원</td>
					  </tr>
					</table>
				  </td>
				</tr>
			  </table>
			<td width='10'></td>
			<td width='170' valign='top'>
			  <table border="0" cellspacing="0" cellpadding="0" width=170>
				<tr>
				  <td class='line'>
					<table border="0" cellspacing="1" cellpadding="0" width=170>
                      <tr>
						<td class='title' width='70'> 연체건수 </td>
						<td style="font-size : 8pt;" align='right' width="100"> 
                          <input type='text' name='s_c' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("DC")))%>' size='3' class='whitenum_8size' >
                          건</td>
					  </tr>
					  <tr>											
                       	<td class='title'> 미수 연체료</td>
						<td style="font-size : 8pt;" align='right'>
						  <input type='text' name='s_s' value='' size='10' class='whitenum_8size' >원</td>
					  </tr>
					  <tr>											
                       	<td class='title'> 수금 연체료</td>
						<td style="font-size : 8pt;" align='right'>
						  <input type='text' name='s_v' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("DT2")))%>' size='10' class='whitenum_8size' >원</td>
					  </tr>
					  <tr>											
                       	<td class='title'> 총연체료</td>
						<td style="font-size : 8pt;" align='right'>
						  <input type='text' name='s_n' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("DT")))%>' size='10' class='whitenum_8size' >원</td>
					  </tr>		
					</table>								
				  </td>
				</tr>
		  		<tr>
		          <td align="right">&nbsp;</td>
		  		</tr>				
			  </table>
			</td>
		  </tr>
		</table>
	  </td>
	</tr>
  </table>
  <%	}else{%>
  <!-- <table border="0" cellspacing="0" cellpadding="0" width=645> -->
  <table border="0" cellspacing="0" cellpadding="0" width=720>
    <tr>
	  <td>
		대여료 통계가 없습니다
	  </td>
	</tr>
  </table>	
  <%	}%>
</form>
<script language='javascript'>
<!--
	set_stat_amt();
	//대여료, 연체료 통계 셋팅
	function set_stat_amt(){
	    var fm = document.form1;
		for(i=0; i<3; i++){ 	
			fm.s_n[i].value = parseDecimal(toInt(parseDigit(fm.s_s[i].value)) + toInt(parseDigit(fm.s_v[i].value)));		
			fm.t_c.value = parseDecimal(toInt(parseDigit(fm.t_c.value)) + toInt(parseDigit(fm.s_c[i].value)));
			fm.t_s.value = parseDecimal(toInt(parseDigit(fm.t_s.value)) + toInt(parseDigit(fm.s_s[i].value)));
			fm.t_v.value = parseDecimal(toInt(parseDigit(fm.t_v.value)) + toInt(parseDigit(fm.s_v[i].value)));
			fm.t_n.value = parseDecimal(toInt(parseDigit(fm.t_n.value)) + toInt(parseDigit(fm.s_n[i].value)));
		}		
			fm.s_s[3].value = parseDecimal(toInt(parseDigit(fm.s_n[3].value)) - toInt(parseDigit(fm.s_v[3].value)));
			
	//	var fm = document.form1;
	//	for(i=0; i<3; i++){ 	
	//		fm.t_c.value = parseDecimal(toInt(parseDigit(fm.t_c.value)) + toInt(parseDigit(fm.s_c[i].value)));
	//		fm.t_s.value = parseDecimal(toInt(parseDigit(fm.t_s.value)) + toInt(parseDigit(fm.s_s[i].value)));
	//		fm.t_v.value = parseDecimal(toInt(parseDigit(fm.t_v.value)) + toInt(parseDigit(fm.s_v[i].value)));
	//		fm.t_n.value = parseDecimal(toInt(parseDigit(fm.t_n.value)) + toInt(parseDigit(fm.s_n[i].value)));
	//	}	
			
	}
	
//-->
</script>  
</body>
</html>
