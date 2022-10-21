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
	
	//�⺻����
	Hashtable fee = af_db.getFeebase(m_id, l_cd);
	
	//���������  ������ ����Ʈ
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
            <td width="400"> <font color="red"> ��������� ������ ��ȸ �� ���� </font> </td>
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
                  <td width='10%' class='title' style="font-size : 8pt;">����ȣ</td>
                  <td width='17%'>&nbsp;<%=fee.get("RENT_L_CD")%></td>
                  <td width='10%' class='title' style="font-size : 8pt;">��ȣ</td>
                  <td  colspan="3">&nbsp;<%=fee.get("FIRM_NM")%></td>
                  <td width='10%' class='title' style="font-size : 8pt;">����</td>
                  <td width='17%'>&nbsp;<%=fee.get("CLIENT_NM")%></td>
                </tr>
                <tr> 
                  <td class='title' style="font-size : 8pt;">������ȣ</td>
                  <td>&nbsp;<font color="#000099"><b><%=fee.get("CAR_NO")%></b></font></td>
                  <td class='title' style="font-size : 8pt;">����</td>
                  <td colspan="3">&nbsp;<%=fee.get("CAR_NM")%></td>
                  <td class='title' style="font-size : 8pt;">�뿩���</td>
                  <td>&nbsp;<%if(fee.get("RENT_WAY").equals("1")){%>
                    �Ϲݽ� 
                    <%}else if(fee.get("RENT_WAY").equals("2")){%>
                    ����� 
                    <%}else{%>
                    �⺻�� 
                    <%}%></td>
                </tr>
                <tr> 
                  <td class='title' style="font-size : 8pt;">ä������</td>
                  <td>&nbsp;<%=fee.get("GI_ST")%></td>
                  <td class='title' style="font-size : 8pt;">�뿩�Ⱓ</td>
                  <td>&nbsp;<%= fee.get("CON_MON")%>����</td>
                  <td width='10%' class='title' style="font-size : 8pt;">������</td>
                  <td width='13%'>&nbsp;<%=fee.get("RENT_START_DT")%></td>
                  <td width='10%' class='title' style="font-size : 8pt;">������</td>
                  <td width='13%'>&nbsp;<%=fee.get("RENT_END_DT")%></td>
                </tr>
                <tr> 
                  <td class='title' style="font-size : 8pt;"> ������ </td>
                  <td>&nbsp;<%=Util.parseDecimal(String.valueOf(fee.get("PP_AMT")))%>��&nbsp;</td>
                  <td class='title' style="font-size : 8pt;"> ������ </td>
                  <td>&nbsp;<%=Util.parseDecimal(String.valueOf(fee.get("GRT_AMT")))%>��&nbsp;</td>
                  <td class='title' style="font-size : 8pt;">���ô뿩��</td>
                  <td>&nbsp;<%=Util.parseDecimal(String.valueOf(fee.get("IFEE_AMT")))%>��&nbsp;</td>
                  <td class='title' style="font-size : 8pt;">���뿩��</td>
                  <td>&nbsp;<%=Util.parseDecimal(String.valueOf(fee.get("FEE_AMT")))%>��&nbsp;</td>
                </tr>				
          	<%	String rent_st = String.valueOf(fee.get("RENT_ST"));
		  		for(int i=2; i<=AddUtil.parseInt(rent_st); i++){
					ContFeeBean ext_fee = a_db.getContFeeNew(m_id, l_cd, Integer.toString(i));
					if(!ext_fee.getCon_mon().equals("")){%>		
				<tr></tr>				
                <tr> 
                  <td class='title' style="font-size : 8pt;">��������</td>
                  <td>&nbsp;<%=ext_fee.getRent_start_dt()%></td>
                  <td class='title' style="font-size : 8pt;">�뿩�Ⱓ</td>
                  <td>&nbsp;<%=ext_fee.getCon_mon()%>����</td>
                  <td class='title' style="font-size : 8pt;">������</td>
                  <td>&nbsp;<%=ext_fee.getRent_start_dt()%></td>
                  <td class='title' style="font-size : 8pt;">������</td>
                  <td>&nbsp;<%=ext_fee.getRent_end_dt()%></td>
                </tr>
                <tr> 
                  <td class='title' style="font-size : 8pt;">������</td>
               	  <td>&nbsp;<%=Util.parseDecimal(ext_fee.getPp_s_amt()+ext_fee.getPp_v_amt())%>��&nbsp;&nbsp;</td>
                  <td class='title' style="font-size : 8pt;">������</td>
                  <td>&nbsp;<%=Util.parseDecimal(ext_fee.getGrt_amt_s())%>��&nbsp;&nbsp;</td>
                  <td class='title' style="font-size : 8pt;">���ô뿩��</td>
                  <td>&nbsp;<%=Util.parseDecimal(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())%>��</td>
                  <td class='title' style="font-size : 8pt;">���뿩��</td>
                  <td>&nbsp;<%=Util.parseDecimal(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt())%>��&nbsp;</td>
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
            <td><<��������� ���� ������>></td>
            <td align='right'>&nbsp;</td>
        </tr>
        <tr> 
            <td class=line colspan='2'> 
                <table border="0" cellspacing="1" cellpadding="0" width="645">
                    <tr>           
                        <td style="font-size : 8pt;" width=35 class='title'>����</td>
                        <td style="font-size : 8pt;" width=90 class='title'>�Աݿ�����</td>
                        <td style="font-size : 8pt;" width=70 class='title'>���ް�</td>
                        <td style="font-size : 8pt;" width=70 class='title'>�ΰ���</td>
                        <td style="font-size : 8pt;" width=70 class='title'>������</td>
                        <td style="font-size : 8pt;" width=90 class='title'>�Ա�����</td>
                        <td style="font-size : 8pt;" width=70 class='title'>���Աݾ�</td>
                        <td style="font-size : 8pt;" width=70 class='title'>��ü�ϼ�</td>
                        <td style="font-size : 8pt;" width=70 class='title'>��ü��</td>   
                    </tr>
                          
        <%	if(cls_scd_size>0){
        		for(int i = 0 ; i < cls_scd_size ; i++){
        			ExtScdBean cls = (ExtScdBean)cls_scd.elementAt(i);%>
        	        <input type='hidden' name='ht_cls_tm' value='<%=cls.getExt_tm()%>'>		
        		    <input type='hidden' name='ht_rent_seq' value='<%=cls.getRent_seq()%>'>				
        <%	   		if(cls.getGubun().equals("�̼���")){ //���Ա� %>
                    <tr> 
                        <td style="font-size : 8pt;" align='center' ><%=i+1%></td>
                        <td style="font-size : 8pt;" align='center' ><input type='text' name='cls_est_dt' size='11' value='<%=cls.getExt_est_dt()%>' class='whitenum_8size' readonly ></td>
                        <td style="font-size : 8pt;" align='right' ><input type='text' name='cls_s_amt' size='9' value='<%=Util.parseDecimal(cls.getExt_s_amt())%>' class='whitenum_8size' readonly >��&nbsp;</td>
                        <td style="font-size : 8pt;" align='right' ><input type='text' name='cls_v_amt' size='9' value='<%=Util.parseDecimal(cls.getExt_v_amt())%>' class='whitenum_8size' readonly >��&nbsp;</td>
                        <td style="font-size : 8pt;" align='right' ><input type='text' name='cls_amt' size='9' value='<%=Util.parseDecimal(cls.getExt_s_amt()+cls.getExt_v_amt())%>' class='whitenum_8size' readonly >��&nbsp;</td>
                        <td style="font-size : 8pt;" align='center'><input type='text' name='pay_dt' size='11' value='<%=cls.getExt_pay_dt()%>' class='whitenum_8size' readonly ></td>
                        <td style="font-size : 8pt;" align='right' ><input type='text' name='pay_amt' size='9' value='<%=Util.parseDecimal(cls.getExt_pay_amt())%>' class='whitenum_8size' readonly >��&nbsp;</td>
                        <td style="font-size : 8pt;" align='right' ><%=cls.getDly_days()%>��&nbsp;</td>
                        <td style="font-size : 8pt;" align='right' ><%=Util.parseDecimal(cls.getDly_amt())%>��&nbsp;</td>
                    </tr>
                <%	} else {//�Ա�%>
                    <tr> 
                        <td style="font-size : 8pt;" align='center'><%=i+1%></td>
                        <td style="font-size : 8pt;" align='center'><input type='text' name='cls_est_dt' size='11' value='<%=cls.getExt_est_dt()%>' class='whitenum_8size' readonly ></td>
                        <td style="font-size : 8pt;" align='right' ><input type='text' name='cls_s_amt' size='9' value='<%=Util.parseDecimal(cls.getExt_s_amt())%>' class='whitenum_8size' readonly >��&nbsp;</td>
                        <td style="font-size : 8pt;" align='right' ><input type='text' name='cls_v_amt' size='9' value='<%=Util.parseDecimal(cls.getExt_v_amt())%>' class='whitenum_8size' readonly >��&nbsp;</td>			
                        <td style="font-size : 8pt;" align='right' ><input type='text' name='cls_amt' size='9' value='<%=Util.parseDecimal(cls.getExt_s_amt()+cls.getExt_v_amt())%>' class='whitenum_8size' readonly >��&nbsp;</td>
                        <td style="font-size : 8pt;" align='center'><input type='text' name='pay_dt' size='11' value='<%=cls.getExt_pay_dt()%>' class='whitenum_8size' readonly ></td>
                        <td style="font-size : 8pt;" align='right' ><input type='text' name='pay_amt' size='9' value='<%=Util.parseDecimal(cls.getExt_pay_amt())%>' class='whitenum_8size' readonly >��&nbsp;</td>
                        <td style="font-size : 8pt;" align='right' ><%=cls.getDly_days()%>��&nbsp;</td>
                        <td style="font-size : 8pt;" align='right' ><%=Util.parseDecimal(cls.getDly_amt())%>��&nbsp;</td>
                    </tr>		  
        <%			}
        		}
        	}else{%>
                    <tr> 
                        <td colspan='9' align='center'>��������� �������� �����ϴ� </td>
                    </tr>
        <%	}%>


                </table>
            </td>
        </tr>
    </table>
</form>
 
</body>
</html>
