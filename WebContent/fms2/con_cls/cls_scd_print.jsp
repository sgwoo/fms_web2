<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, acar.cls.*, acar.ext.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
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
	
	//기본정보
	Hashtable fee = af_db.getFeebase(m_id, l_cd);
	
	//해지정산금  스케줄 리스트
	Vector cls_scd = ae_db.getClsScd(m_id, l_cd);
	int cls_scd_size = cls_scd.size();

%>
<form name='form1' action='' method='post' target=''>
<input type='hidden' name='cls_chk' value='<%=cls_chk%>'>
<input type='hidden' name='bill_yn' value='<%=bill_yn%>'>
<input type='hidden' name='b_dt' value='<%=b_dt%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=645>
    <tr>
	  <td>
	    <table width="645">
          <tr>
            <td width="400"> <font color="red"> 해지정산금 스케줄 조회 및 수금 </font> </td>
            <td align="right"><a href="javascript:printWin()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_print.gif"  align="absmiddle" border="0"></a> 
            </td>		  
		  </tr>		
	    </table>  
	  </td> 
    </tr>
    <tr> 
      <td colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=645>
          <tr> 
            <td class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                  <td width='10%' class='title' style="font-size : 8pt;">계약번호</td>
                  <td width='17%'>&nbsp;<%=fee.get("RENT_L_CD")%></td>
                  <td width='10%' class='title' style="font-size : 8pt;">상호</td>
                  <td  colspan="3">&nbsp;<%=fee.get("FIRM_NM")%></td>
                  <td width='10%' class='title' style="font-size : 8pt;">고객명</td>
                  <td width='17%'>&nbsp;<%=fee.get("CLIENT_NM")%></td>
                </tr>
                <tr> 
                  <td class='title' style="font-size : 8pt;">차량번호</td>
                  <td>&nbsp;<font color="#000099"><b><%=fee.get("CAR_NO")%></b></font></td>
                  <td class='title' style="font-size : 8pt;">차명</td>
                  <td colspan="3">&nbsp;<%=fee.get("CAR_NM")%></td>
                  <td class='title' style="font-size : 8pt;">대여방식</td>
                  <td>&nbsp;<%if(fee.get("RENT_WAY").equals("1")){%>
                    일반식 
                    <%}else if(fee.get("RENT_WAY").equals("2")){%>
                    맞춤식 
                    <%}else{%>
                    기본식 
                    <%}%></td>
                </tr>
                <tr> 
                  <td class='title' style="font-size : 8pt;">채권유형</td>
                  <td>&nbsp;<%=fee.get("GI_ST")%></td>
                  <td class='title' style="font-size : 8pt;">대여기간</td>
                  <td>&nbsp;<%= fee.get("CON_MON")%>개월</td>
                  <td width='10%' class='title' style="font-size : 8pt;">개시일</td>
                  <td width='13%'>&nbsp;<%=fee.get("RENT_START_DT")%></td>
                  <td width='10%' class='title' style="font-size : 8pt;">만료일</td>
                  <td width='13%'>&nbsp;<%=fee.get("RENT_END_DT")%></td>
                </tr>
                <tr> 
                  <td class='title' style="font-size : 8pt;"> 선납금 </td>
                  <td>&nbsp;<%=Util.parseDecimal(String.valueOf(fee.get("PP_AMT")))%>원&nbsp;</td>
                  <td class='title' style="font-size : 8pt;"> 보증금 </td>
                  <td>&nbsp;<%=Util.parseDecimal(String.valueOf(fee.get("GRT_AMT")))%>원&nbsp;</td>
                  <td class='title' style="font-size : 8pt;">개시대여료</td>
                  <td>&nbsp;<%=Util.parseDecimal(String.valueOf(fee.get("IFEE_AMT")))%>원&nbsp;</td>
                  <td class='title' style="font-size : 8pt;">월대여료</td>
                  <td>&nbsp;<%=Util.parseDecimal(String.valueOf(fee.get("FEE_AMT")))%>원&nbsp;</td>
                </tr>				
          	<%	String rent_st = String.valueOf(fee.get("RENT_ST"));
		  		for(int i=2; i<=AddUtil.parseInt(rent_st); i++){
					ContFeeBean ext_fee = a_db.getContFeeNew(m_id, l_cd, Integer.toString(i));
					if(!ext_fee.getCon_mon().equals("")){%>		
				<tr></tr>				
                <tr> 
                  <td class='title' style="font-size : 8pt;">연장계약일</td>
                  <td>&nbsp;<%=ext_fee.getRent_start_dt()%></td>
                  <td class='title' style="font-size : 8pt;">대여기간</td>
                  <td>&nbsp;<%=ext_fee.getCon_mon()%>개월</td>
                  <td class='title' style="font-size : 8pt;">개시일</td>
                  <td>&nbsp;<%=ext_fee.getRent_start_dt()%></td>
                  <td class='title' style="font-size : 8pt;">만료일</td>
                  <td>&nbsp;<%=ext_fee.getRent_end_dt()%></td>
                </tr>
                <tr> 
                  <td class='title' style="font-size : 8pt;">선납금</td>
               	  <td>&nbsp;<%=Util.parseDecimal(ext_fee.getPp_s_amt()+ext_fee.getPp_v_amt())%>원&nbsp;&nbsp;</td>
                  <td class='title' style="font-size : 8pt;">보증금</td>
                  <td>&nbsp;<%=Util.parseDecimal(ext_fee.getGrt_amt_s())%>원&nbsp;&nbsp;</td>
                  <td class='title' style="font-size : 8pt;">개시대여료</td>
                  <td>&nbsp;<%=Util.parseDecimal(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())%>원</td>
                  <td class='title' style="font-size : 8pt;">월대여료</td>
                  <td>&nbsp;<%=Util.parseDecimal(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt())%>원&nbsp;</td>
                </tr>
          	<%		}
		  		}%>
            			
              </table>
            </td>
          </tr>
    	</table>
	  </td>
  	</tr>
  </table>
   <table border="0" cellspacing="1" cellpadding="0" width=645>
        <tr> 
            <td><<해지정산금 수금 스케쥴>></td>
            <td align='right'>&nbsp;</td>
        </tr>
        <tr> 
            <td class=line colspan='2'> 
                <table border="0" cellspacing="1" cellpadding="0" width="645">
                    <tr>           
                        <td style="font-size : 8pt;" width=35 class='title'>연번</td>
                        <td style="font-size : 8pt;" width=90 class='title'>입금예정일</td>
                        <td style="font-size : 8pt;" width=70 class='title'>공급가</td>
                        <td style="font-size : 8pt;" width=70 class='title'>부가세</td>
                        <td style="font-size : 8pt;" width=70 class='title'>해지금</td>
                        <td style="font-size : 8pt;" width=90 class='title'>입금일자</td>
                        <td style="font-size : 8pt;" width=70 class='title'>실입금액</td>
                        <td style="font-size : 8pt;" width=70 class='title'>연체일수</td>
                        <td style="font-size : 8pt;" width=70 class='title'>연체료</td>   
                    </tr>
                          
        <%	if(cls_scd_size>0){
        		for(int i = 0 ; i < cls_scd_size ; i++){
        			ExtScdBean cls = (ExtScdBean)cls_scd.elementAt(i);%>
        	        <input type='hidden' name='ht_cls_tm' value='<%=cls.getExt_tm()%>'>		
        		    <input type='hidden' name='ht_rent_seq' value='<%=cls.getRent_seq()%>'>				
        <%	   		if(cls.getGubun().equals("미수금")){ //미입금 %>
                    <tr> 
                        <td style="font-size : 8pt;" align='center' ><%=i+1%></td>
                        <td style="font-size : 8pt;" align='center' ><input type='text' name='cls_est_dt' size='11' value='<%=cls.getExt_est_dt()%>' class='whitenum_8size' readonly ></td>
                        <td style="font-size : 8pt;" align='right' ><input type='text' name='cls_s_amt' size='9' value='<%=Util.parseDecimal(cls.getExt_s_amt())%>' class='whitenum_8size' readonly >원&nbsp;</td>
                        <td style="font-size : 8pt;" align='right' ><input type='text' name='cls_v_amt' size='9' value='<%=Util.parseDecimal(cls.getExt_v_amt())%>' class='whitenum_8size' readonly >원&nbsp;</td>
                        <td style="font-size : 8pt;" align='right' ><input type='text' name='cls_amt' size='9' value='<%=Util.parseDecimal(cls.getExt_s_amt()+cls.getExt_v_amt())%>' class='whitenum_8size' readonly >원&nbsp;</td>
                        <td style="font-size : 8pt;" align='center'><input type='text' name='pay_dt' size='11' value='<%=cls.getExt_pay_dt()%>' class='whitenum_8size' readonly ></td>
                        <td style="font-size : 8pt;" align='right' ><input type='text' name='pay_amt' size='9' value='<%=Util.parseDecimal(cls.getExt_pay_amt())%>' class='whitenum_8size' readonly >원&nbsp;</td>
                        <td style="font-size : 8pt;" align='right' ><%=cls.getDly_days()%>일&nbsp;</td>
                        <td style="font-size : 8pt;" align='right' ><%=Util.parseDecimal(cls.getDly_amt())%>원&nbsp;</td>
                    </tr>
                <%	} else {//입금%>
                    <tr> 
                        <td style="font-size : 8pt;" align='center'><%=i+1%></td>
                        <td style="font-size : 8pt;" align='center'><input type='text' name='cls_est_dt' size='11' value='<%=cls.getExt_est_dt()%>' class='whitenum_8size' readonly ></td>
                        <td style="font-size : 8pt;" align='right' ><input type='text' name='cls_s_amt' size='9' value='<%=Util.parseDecimal(cls.getExt_s_amt())%>' class='whitenum_8size' readonly >원&nbsp;</td>
                        <td style="font-size : 8pt;" align='right' ><input type='text' name='cls_v_amt' size='9' value='<%=Util.parseDecimal(cls.getExt_v_amt())%>' class='whitenum_8size' readonly >원&nbsp;</td>			
                        <td style="font-size : 8pt;" align='right' ><input type='text' name='cls_amt' size='9' value='<%=Util.parseDecimal(cls.getExt_s_amt()+cls.getExt_v_amt())%>' class='whitenum_8size' readonly >원&nbsp;</td>
                        <td style="font-size : 8pt;" align='center'><input type='text' name='pay_dt' size='11' value='<%=cls.getExt_pay_dt()%>' class='whitenum_8size' readonly ></td>
                        <td style="font-size : 8pt;" align='right' ><input type='text' name='pay_amt' size='9' value='<%=Util.parseDecimal(cls.getExt_pay_amt())%>' class='whitenum_8size' readonly >원&nbsp;</td>
                        <td style="font-size : 8pt;" align='right' ><%=cls.getDly_days()%>일&nbsp;</td>
                        <td style="font-size : 8pt;" align='right' ><%=Util.parseDecimal(cls.getDly_amt())%>원&nbsp;</td>
                    </tr>		  
        <%			}
        		}
        	}else{%>
                    <tr> 
                        <td colspan='9' align='center'>해지정산금 스케줄이 없습니다 </td>
                    </tr>
        <%	}%>


                </table>
            </td>
        </tr>
    </table>
</form>
 
</body>
</html>
