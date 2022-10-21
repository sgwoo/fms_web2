<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.estimate_mng.*, acar.user_mng.*, acar.car_mst.*, acar.util.*, acar.common.*" %>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="cm_bean2" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>

<%
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	String acar_id 		= request.getParameter("acar_id")	==null?"":request.getParameter("acar_id");
	String est_id 		= request.getParameter("est_id")	==null?"":request.getParameter("est_id");
	
	String mail_st 		= request.getParameter("mail_st")	==null?"":request.getParameter("mail_st");
	
	String opt_chk		= request.getParameter("opt_chk")	==null?"0":request.getParameter("opt_chk");	
	String fee_opt_amt 	= request.getParameter("fee_opt_amt")	==null?"0":request.getParameter("fee_opt_amt");
	String content_st 	= request.getParameter("content_st")	==null?"":request.getParameter("content_st");
	
	String reg_id 		= request.getParameter("write_id")	==null?"":request.getParameter("write_id");
	String est_m_tel	= request.getParameter("est_m_tel")	==null?"":request.getParameter("est_m_tel");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	e_bean = e_db.getEstimateCase(est_id);
	
	//�����
	String u_nm ="";
	String u_mt ="";
	String u_ht ="";
	
	UserMngDatabase umdb = UserMngDatabase.getInstance();
	
	UsersBean user_bean = umdb.getUsersBean(e_bean.getReg_id());
	
	u_nm = user_bean.getUser_nm();
	u_mt = user_bean.getUser_m_tel();
	u_ht = user_bean.getHot_tel();	
	
	//CAR_NM : ��������
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	cm_bean2 = a_cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());
	
	//��������
	Hashtable ht = shDb.getShBase(e_bean.getMgr_nm());
	String car_no 				= String.valueOf(ht.get("CAR_NO"));
	String init_reg_dt 		= String.valueOf(ht.get("INIT_REG_DT"));
	
	//�ܰ� ��������
	Hashtable sh_var = shDb.getShBaseVar(e_bean.getMgr_nm());
	int dlv_car_amt			= AddUtil.parseInt((String)sh_var.get("DLV_CAR_AMT"));
	
	String url1 = "";
	if(content_st.equals("sh_fms_ym")){ //��������������� ������� ���ڰ� �߼۵ǰ� ���� (20180919)
		url1 = "http://fms1.amazoncar.co.kr/acar/secondhand_hp/estimate_fms_ym.jsp?est_id="+est_id+"&acar_id="+acar_id+"&from_page=/acar/estimate_mng/esti_mng_u.jsp&content_st="+content_st;
	}else{
		url1 = "http://fms1.amazoncar.co.kr/acar/secondhand_hp/estimate_fms.jsp?est_id="+est_id+"&acar_id="+acar_id+"&from_page=/acar/estimate_mng/esti_mng_u.jsp&content_st="+content_st;
	}
	
	System.out.println("[���� ���ڹ߼� �Է��ϱ�] est_id = "+est_id);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns=��http://www.w3.org/1999/xhtml��>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>������ ���ں�����</title>
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="apple-mobile-web-app-status-bar-style" content="black" />


<meta name="viewport" content="width=device-width,height=device-height,user-scalable=yes,initial-scale=1.0;"> 
<style type="text/css">
<!--
body.general		{ background-color:#FFFFFF; font-family: ����, Gulim, AppleGothic, Seoul, Arial; font-size: 9pt; }
.style2 		{ color: #515150; font-weight: bold; font-size:9pt; }
-->
<!--
body {
	margin-left: 0px;
	margin-right: 0px;
	margin-top: 0px;
	margin-bottom: 0px;
	background-color:#f4f3f3;
	font-family: ����; font-size: 9pt;
}
-->
</style>
<script>
<!--
	function EnterDown(){
		var keyValue = event.keyCode;
		if (keyValue =='13') send_mail();
	}

	//���ϼ����ϱ�
	function send_mail(){
		var fm = document.form1;
		var addr = fm.est_m_tel.value;
		
		if(fm.est_id.value == '') { alert('�������� ���õ��� �ʾҽ��ϴ�. ���Ϲ߼��� �ȵ˴ϴ�.'); return; }
		if(addr=="")			{ alert("���Ź�ȣ�� �Է����ּ���!"); fm.est_m_tel.focus(); return; }		
		
		if(fm.sms1_yn.checked == false && fm.sms2_yn.checked == false){
			alert('�߼��� ���ڸ� üũ�Ͻʽÿ�.'); return;	
		}
			
		if(!confirm('�� ��ȣ�� ������ڸ� �߼��Ͻðڽ��ϱ�?')){	return; }		

		fm.action = "send_sms.jsp";
		fm.target = "i_no";
		fm.submit();
	}
	
//-->
</script>
</head>

<body onLoad="document.form1.est_m_tel.focus();">
<form name="form1" method="post" action="">
<input type="hidden" name="from_page" 	value="<%= from_page %>">
<input type="hidden" name="est_id" 	value="<%= est_id %>">
<input type="hidden" name="acar_id" 	value="<%= acar_id %>">
<input type="hidden" name="mail_st" 	value="<%= mail_st %>">
<input type="hidden" name="opt_chk" 	value="<%=opt_chk%>">
<input type="hidden" name="fee_opt_amt" value="<%=fee_opt_amt%>">
<input type="hidden" name="content_st" 	value="<%= content_st %>">
<input type="hidden" name="reg_id" 	value="<%= reg_id %>">

<table width=440 border=0 cellspacing=0 cellpadding=0>
    <tr>
	<td bgcolor=#9acbe1 height=5></td>
    </tr>
    <tr>
	<td height=20></td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/sms_1.gif alt='������ ���ں�����'></td>
    </tr>
    <tr>
	<td height=10></td>
    </tr>
    <tr>
    	<td align=center>
    	    <table width=392 border=0 cellspacing=0 cellpadding=0 background=/acar/images/center/mail_bg.gif>
    		<tr>
    		    <td><img src=/acar/images/center/mail_up.gif></td>
    		</tr>
    		<tr>
    		    <td height=20></td>
    		</tr>
    		<tr>
    		    <td align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/mail_2.gif alt='����'></td>
    		</tr>
    		<tr>
    		    <td height=7></td>
    		</tr>
    		<tr>
    		    <td align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/mail_arrow.gif> &nbsp;<span class=style2>���Ź�ȣ &nbsp;<input type="text" name="est_m_tel" size="30" onKeydown="javascript:EnterDown()" value='<%=est_m_tel%>'></span></td>
    		</tr>
    		<tr>
    		    <td height=30></td>
    		</tr>
    		<tr>
    		    <td height=7></td>
    		</tr>
    		<tr>
    		    <td align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/mail_arrow.gif> &nbsp;<span class=style2><input type="checkbox" name="sms1_yn" value="Y"> �߼۾ȳ����� &nbsp;</span></td>
    		</tr>
    		<tr>
    		    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="sms_cont1" value="<%=e_bean.getEst_nm()%> ���Բ��� ��û�Ͻ� ��������" size="45" readOnly><br>
    		    	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select name='sms_cont2'>            
                        <option value="">����</option>					
                        <option value="�ѽ�" selected>�ѽ�</option>
                        <option value="����">����</option>
					      </select><br>
					      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<textarea name="sms_cont3" cols="45" rows="4" readOnly>�� �������� Ȯ�� �ٶ��ϴ�. �ñ��� ���� ������ �������� ��ȭ�ּ���. ����ڴ� <%=u_nm%> <%=u_mt%> �Դϴ�. (��)�Ƹ���ī</textarea>
					      <input type="hidden" name="u_nm" value="<%=u_nm%>">
					      <input type="hidden" name="u_mt" value="<%=u_mt%>">
					      <input type="hidden" name="est_nm" value="<%=e_bean.getEst_nm()%>">
    		    </td>
    		</tr>			
    		<tr>
    		    <td height=7></td>
    		</tr>    		
    		<tr>
    		    <td align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/mail_arrow.gif> &nbsp;<span class=style2><input type="checkbox" name="sms2_yn" value="Y"> ����������� &nbsp;</span></td>
    		</tr>

    		<tr>
    		    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<textarea name="wap_msg_body" cols="45" rows="7" readOnly>������ ��û�Ͻ� �����ȳ�. <%if(e_bean.getEst_st().equals("2")){%>[����]<%}else{%>[�縮��]<%}%><%=car_no%> <%=cm_bean2.getCar_nm()%> <%=AddUtil.parseDecimal(e_bean.getO_1()+dlv_car_amt)%>�� <%if(!init_reg_dt.equals("") && init_reg_dt.length() == 8){%><%=AddUtil.getDate3(init_reg_dt).substring(0,9)%>��<%}%> <%= AddUtil.parseDecimal(e_bean.getToday_dist()) %>km <%=c_db.getNameByIdCode("0009", "", e_bean.getA_a())%><%if(e_bean.getA_a().equals("11") || e_bean.getA_a().equals("21")){%>(��������)<%}%> <%=e_bean.getA_b()%>���� ������<%=e_bean.getRg_8()%>% <%=AddUtil.parseDecimal(e_bean.getFee_s_amt()+e_bean.getFee_v_amt())%>�� VAT����(������ ���� : <%=ShortenUrlGoogle.getShortenUrl(url1) %>  ) ����ڴ� <%=u_nm%> <%=u_mt%> �Դϴ�. (��)�Ƹ���ī</textarea>
					    <input type="hidden" name="a_url" value="<%=ShortenUrlGoogle.getShortenUrl(url1)%>">    
					    <input type="hidden" name="a_car_name" value="<%if(e_bean.getEst_st().equals("2")){%>[����]<%}else{%>[�縮��]<%}%><%=car_no%> <%=cm_bean2.getCar_nm()%>">
					    <input type="hidden" name="a_gubun1" value="<%if(!init_reg_dt.equals("") && init_reg_dt.length() == 8){%><%=AddUtil.getDate3(init_reg_dt).substring(0,9)%>��<%}%> <%= AddUtil.parseDecimal(e_bean.getToday_dist()) %>km">
					    <input type="hidden" name="a_gubun2" value="<%=c_db.getNameByIdCode("0009", "", e_bean.getA_a())%>">
					    <input type="hidden" name="a_car_amount" value="<%=AddUtil.parseDecimal(e_bean.getO_1()+dlv_car_amt)%>">                           
					    
    		    	</td>
    		</tr>			
    		<tr>
    		    <td height=7></td>
    		</tr>
		<tr>
    		    <td height=20></td>
    		</tr>
    		<tr>
    		    <td><img src=/acar/images/center/mail_dw.gif></td>
    		</tr>
    	    </table>
    	</td>
    </tr>
    <tr>
    	<td height=10></td>
    </tr>
    <tr>
    	<td align=center><a href="javascript:send_mail();"><img src=/acar/images/center/mail_btn_send.gif border="0" alt='������'></a></td>
    </tr>   
</table>


</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>




</body>
</html>

