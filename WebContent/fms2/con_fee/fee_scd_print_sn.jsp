<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, acar.cls.*"%>
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
	
	//�⺻����
	Hashtable fee = af_db.getFeebaseNew(m_id, l_cd);
	
	//���ʴ뿩����
	ContFeeBean f_fee = a_db.getContFeeNew(m_id, l_cd, "1");
	
	//��������
	ClsBean cls = as_db.getClsCase(m_id, l_cd);
	
	//�Ǻ� �뿩�� ������ ����Ʈ
	Vector fee_scd = af_db.getFeeScdNew2(m_id, l_cd, b_dt, mode, bill_yn, false);	// ������ ���� 2018.04.16
	int fee_scd_size = fee_scd.size();
	
	// ������ 2018.04.16
	Vector fee_scd_sun_nap = af_db.getFeeScdNew2(m_id, l_cd, b_dt, mode, bill_yn, true);
	int fee_scd_sun_nap_size = fee_scd_sun_nap.size();
	
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
	
	//�Ǻ� �뿩�� ������ ���
	Hashtable fee_stat = af_db.getFeeScdStatNew(m_id, l_cd, b_dt, mode, bill_yn);
	int fee_stat_size = fee_stat.size();
%>
<form name='form1' action='' method='post' target=''>
<input type='hidden' name='cls_chk' value='<%=cls_chk%>'>
<input type='hidden' name='bill_yn' value='<%=bill_yn%>'>
<input type='hidden' name='b_dt' value='<%=b_dt%>'>
  <table border="0" cellspacing="0" cellpadding="0" width="720">
    <tr>
	  <td>
	    <table width="720">
          <tr>
            <td width="400"> <font color="red"> �뿩�� ������ ��ȸ �� ���� </font> </td>
            <td align="right"><a href="javascript:printWin()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_print.gif"  align="absmiddle" border="0"></a> 
            </td>		  
		  </tr>		
	    </table>  
	  </td> 
    </tr>
    <tr> 
      <td colspan="2"> 
        <!-- <table border="0" cellspacing="1" cellpadding="0" width=645> -->
        <table border="0" cellspacing="1" cellpadding="0" width="720"> 
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
                  <td>&nbsp;<%=f_fee.getCon_mon()%>����</td>
                  <td width='10%' class='title' style="font-size : 8pt;">������</td>
                  <td width='13%'>&nbsp;<%=AddUtil.ChangeDate2(f_fee.getRent_start_dt())%></td>
                  <td width='10%' class='title' style="font-size : 8pt;">������</td>
                  <td width='13%'>&nbsp;<%=AddUtil.ChangeDate2(f_fee.getRent_end_dt())%></td>
                </tr>
                <tr> 
                  <td class='title' style="font-size : 8pt;"> ������ </td>
                  <td>&nbsp;<%=Util.parseDecimal(f_fee.getPp_s_amt()+f_fee.getPp_v_amt())%>��&nbsp;</td>
                  <td class='title' style="font-size : 8pt;"> ������ </td>
                  <td>&nbsp;<%=Util.parseDecimal(f_fee.getGrt_amt_s())%>��&nbsp;</td>
                  <td class='title' style="font-size : 8pt;">���ô뿩��</td>
                  <td>&nbsp;<%=Util.parseDecimal(f_fee.getIfee_s_amt()+f_fee.getIfee_v_amt())%>��&nbsp;</td>
                  <td class='title' style="font-size : 8pt;">���뿩��</td>
                  <td>&nbsp;<%=Util.parseDecimal(f_fee.getFee_s_amt()+f_fee.getFee_v_amt())%>��&nbsp;</td>
                </tr>				
          	<%	String rent_st = String.valueOf(fee.get("RENT_ST"));
		  		for(int i=2; i<=AddUtil.parseInt(rent_st); i++){
					ContFeeBean ext_fee = a_db.getContFeeNew(m_id, l_cd, Integer.toString(i));
					if(!ext_fee.getCon_mon().equals("")){%>		
				<tr></tr>				
                <tr> 
                  <td class='title' style="font-size : 8pt;">��������</td>
                  <td>&nbsp;<%=AddUtil.ChangeDate2(ext_fee.getRent_start_dt())%></td>
                  <td class='title' style="font-size : 8pt;">�뿩�Ⱓ</td>
                  <td>&nbsp;<%=ext_fee.getCon_mon()%>����</td>
                  <td class='title' style="font-size : 8pt;">������</td>
                  <td>&nbsp;<%=AddUtil.ChangeDate2(ext_fee.getRent_start_dt())%></td>
                  <td class='title' style="font-size : 8pt;">������</td>
                  <td>&nbsp;<%=AddUtil.ChangeDate2(ext_fee.getRent_end_dt())%></td>
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
  <table border="0" cellspacing="0" cellpadding="0" width=720>
    <tr> 
      <td width="400">&#60;&#60;�����뿩��յ���� ������&#62;&#62;</td>
      <td align='right' width="400">&nbsp;</td>
    </tr>
    <tr> 
      <td class=line colspan='2'> 
        <table border="0" cellspacing="1" cellpadding="0" width="720">
          <tr> 
            <td style="font-size : 8pt;" class='title' width="20">ȸ<br>��</td>
            <td style="font-size : 8pt;" class='title' width="40">����</td>
            <td style="font-size : 8pt;" class='title' width="110">���Ⱓ</td>
            <td style="font-size : 8pt;" class='title' width="60">���ݰ�꼭����</td>			
            <td style="font-size : 8pt;" class='title' width="65">���ް�</td>
            <td style="font-size : 8pt;" class='title' width="60">�ΰ���</td>
            <td style="font-size : 8pt;" class='title' width="65">���뿩��</td>
            <td style="font-size : 8pt;" class='title' width="55">�Ա�����</td>
            <td style="font-size : 8pt;" class='title' width="70">���Աݾ�</td>
            <td style="font-size : 8pt;" class='title' width="50">��ü<br>�ϼ�</td>
            <td style="font-size : 8pt;" class='title' width="45">��ü��</td>
            <td style="font-size : 8pt;" class='title' width="75">���ݰ�꼭<br>��������</td>
          </tr>
          <%for(int j = 0 ; j < fee_scd_sun_nap_size ; j++){
				FeeScdBean a_fee = (FeeScdBean)fee_scd_sun_nap.elementAt(j);
				if(!a_fee.getTm_st1().equals("0") && a_fee.getBill_yn().equals("N")) continue;				
				if(a_fee.getBill_yn().equals("Y") || a_fee.getRc_amt() >0){%>
          <tr> 
            <td style="font-size : 8pt;" align='center'><%=a_fee.getFee_tm()%></td><!-- ȸ�� -->
            <td style="font-size : 8pt;" align='center'><%if(a_fee.getTm_st1().equals("0")){%>�뿩��<%}else{%>�ܾ�<%}%></td><!-- ���� -->
            <td style="font-size : 8pt;" align='center'><%=a_fee.getUse_s_dt()%>~<%=a_fee.getUse_e_dt()%></td><!-- ���Ⱓ -->
            <td style="font-size : 8pt;" align='center'><%=a_fee.getTax_out_dt()%></td><!-- ���ݰ�꼭���� -->
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_s_amt())%>��</td><!-- ���ް� -->
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_v_amt())%>��</td><!-- �ΰ��� -->
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_s_amt()+a_fee.getFee_v_amt())%>��</td><!-- ���뿩�� -->
			<%		if( a_fee.getRc_dt().equals(AddUtil.replace(cls.getCls_dt(),"-","")) ){%>
            <td style="font-size : 8pt;" align='center'><input type='text' name='pay_dt' size='8' class='whitenum_8size' value=''></td><!-- �Ա����� -->
            <td style="font-size : 8pt;" align='center'><input type='text' name='pay_amt' size='10' class='whitenum_8size' value='0��'></td><!-- ���Աݾ� -->
            <td style="font-size : 8pt;" align='center'><input type='text' name='dly_dt' size='3' class='whitenum_8size'  value='<%=a_fee.getDly_days()%>'>��</td><!-- ��ü�ϼ� -->
            <td style="font-size : 8pt;" align='center'><input type='text' name='dly_amt' size='6' class='whitenum_8size' value='<%=Util.parseDecimal(a_fee.getDly_fee())%>'>��</td>
            <td style="font-size : 8pt;" align='center'><%=AddUtil.ChangeDate2(a_fee.getExt_dt())%></td>
			<%		}else{%>
            <td style="font-size : 8pt;" align='center'><input type='text' name='pay_dt' size='8' class='whitenum_8size' value='<%=a_fee.getRc_dt()%>'></td>
            <td style="font-size : 8pt;" align='center'><input type='text' name='pay_amt' size='10' class='whitenum_8size' value='<%=Util.parseDecimal(a_fee.getRc_amt())%>��'></td>
            <td style="font-size : 8pt;" align='center'><input type='text' name='dly_dt' size='3' class='whitenum_8size'  value='<%=a_fee.getDly_days()%>'>��</td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getDly_fee())%><input type='hidden' name='dly_amt' size='0' class='whitenum_8size' value=''></td>
            <td style="font-size : 8pt;" align='center'><%=AddUtil.ChangeDate2(a_fee.getExt_dt())%></td>			
			<%		}%>
          </tr>
		  <%	}else{%>
          <tr> 
            <td style="font-size : 8pt;" align='center'><%=a_fee.getFee_tm()%></td>
            <td style="font-size : 8pt;" align='center'><%if(a_fee.getTm_st1().equals("0")){%>�뿩��<%}else{%>�ܾ�<%}%></td>
            <td style="font-size : 8pt;" align='center'><%=a_fee.getUse_s_dt()%>~<%=a_fee.getUse_e_dt()%></td>
            <td style="font-size : 8pt;" align='center'><%=a_fee.getFee_est_dt()%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_s_amt())%>��</td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_v_amt())%>��</td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_s_amt()+a_fee.getFee_v_amt())%>��</td>
            <td style="font-size : 8pt;" align='center'><input type='text' name='pay_dt' size='8' class='whitenum_8size' value='<%=AddUtil.replace(cls.getCls_dt(),"-","")%>'></td>
            <td style="font-size : 8pt;" align='center'><input type='text' name='pay_amt' size='10' class='whitenum_8size' value='0��'></td>
            <td style="font-size : 8pt;" align='center'><input type='text' name='dly_dt' size='3' class='whitenum_8size'  value='<%=a_fee.getDly_days()%>'>��</td>
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
  <br/>
</form>
<script language='javascript'>
<!--
	set_stat_amt();
	//�뿩��, ��ü�� ��� ����
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
