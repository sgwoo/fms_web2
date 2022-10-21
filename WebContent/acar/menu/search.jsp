<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*,acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String acar_id = request.getParameter("acar_id")==null?"":request.getParameter("acar_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String ip_auth = request.getParameter("ip_auth")==null?"":request.getParameter("ip_auth");

	//search���� �����ϱ�
	String no = request.getParameter("no")	==null?"":request.getParameter("no");
	String auth_rw = request.getParameter("auth_rw")	==null?"R/W":request.getParameter("auth_rw");
	String m_id = request.getParameter("m_id")	==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")	==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")	==null?"":request.getParameter("c_id");
	String link = "";
	if(!m_id.equals("")) link="&mode=2&auth_rw="+auth_rw+"&m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id;
	String url = "";
	int i_no=Util.parseInt(no);
	switch (i_no){
		case 1 : url="/acar/car_rent/con_frame_s.jsp";
		break;
		case 2 : url="/fms2/con_fee/fee_frame_s.jsp";
		break;
		case 3 : url="/acar/con_debt/debt_frame_s.jsp";
		break;
		case 4 : url="/acar/forfeit_mng/forfeit_s_frame.jsp";
		break;
		case 5 : url="/acar/ins_mng/ins_s_frame.jsp";
		break;
		case 6 : url="/acar/car_service/service_i_frame.jsp";
		break;
		case 7 : url="/acar/car_accident/car_accid_s_frame.jsp";
		break;
	}
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	String dept_id = login.getDept_id(acar_id);	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/index.css">
<script language="javascript">
<!--
	function locationUrl(){			
		<% if(no != ""){%>
			parent.d_content.location ="<%=url%>?<%=link%>";
		<% } %>
	}
	
	function search_pop(){
		window.open('/acar/search/search_frame.jsp', '�˻�', 'width=930,height=400,left=80,top=200');
	}	
	
	//���������� �̵�
	function page_move()
	{
		var fm = document.form1;
		var url = "";
		var idx = fm.gubun1.options[fm.gubun1.selectedIndex].value;		
		if(fm.m_id.value == "" || fm.l_cd.value == ""){
			if(idx == '1') 		url = "/fms2/con_fee/fee_frame_s.jsp";
			else if(idx == '2') url = "/acar/con_grt/grt_frame_s.jsp";
			else if(idx == '3') url = "/acar/con_forfeit/forfeit_frame_s.jsp";
			else if(idx == '4') url = "/acar/con_ins_m/ins_m_frame_s.jsp";
			else if(idx == '5') url = "/acar/con_ins_h/ins_h_frame_s.jsp";
			else if(idx == '6') url = "/acar/con_cls/cls_frame_s.jsp";		
			else if(idx == '7') url = "/acar/settle_acc/settle_s_frame.jsp";	
			else if(idx == '8') url = "/acar/con_debt/debt_frame_s.jsp?f_list=now";
			else if(idx == '9') url = "/acar/ins_mng/ins_s_frame.jsp";		
			else if(idx == '10') url = "/acar/forfeit_mng/forfeit_s_frame.jsp";
			else if(idx == '11') url = "/acar/commi_mng/commi_frame_s.jsp";
			else if(idx == '12') url = "/acar/mng_exp/exp_frame_s.jsp";			
			else if(idx == '13') url = "/acar/con_tax/tax_frame_s.jsp";		
			else if(idx == '20') url = "/acar/car_rent/con_frame_s.jsp";				
			else if(idx == '22') url = "/acar/accid_mng/accid_s_frame.jsp";						
			else if(idx == '23') url = "/acar/car_register/register_s_frame.jsp";									
			else if(idx == '24') url = "/acar/cus0401/cus0401_s_frame.jsp";
			else return;				
		}else{
			if(idx == '1') 		url = "/fms2/con_fee/fee_c_mgr.jsp";
			else if(idx == '2') url = "/acar/con_grt/grt_u.jsp";
			else if(idx == '3') url = "/acar/forfeit_mng/forfeit_i_frame.jsp";					
//			else if(idx == '3') url = "/acar/con_forfeit/forfeit_c.jsp";
			else if(idx == '4') url = "/acar/con_ins_m/ins_m_c.jsp";
			else if(idx == '5') url = "/acar/con_ins_h/ins_h_c.jsp";
			else if(idx == '6') url = "/acar/con_cls/cls_c.jsp";		
			else if(idx == '7') url = "/acar/settle_acc/settle_c.jsp";		
//			else if(idx == '8') url = "/acar/con_debt/debt_c.jsp?f_list=pay";		
			else if(idx == '8') url = "/acar/con_debt/debt_reg_u.jsp?f_list=pay";					
			else if(idx == '9') url = "/acar/ins_mng/ins_u_frame.jsp";		
//			else if(idx == '10') url = "/acar/forfeit_mng/forfeit_i_frame.jsp";		
			else if(idx == '10') url = "/acar/fine_mng/fine_mng_frame.jsp";					
			else if(idx == '11') url = "/acar/commi_mng/commi_u.jsp";										
			else if(idx == '12') url = "/acar/mng_exp/exp_u.jsp";		
			else if(idx == '13') url = "/acar/con_tax/tax_scd_u.jsp";				
			else if(idx == '20') url = "/acar/car_rent/con_reg_frame.jsp?mode=2";				
			else if(idx == '22') url = "/acar/accid_mng/accid_u_frame.jsp";		
			else if(idx == '23'){
				if(fm.c_id.value != "")
					url = "/acar/car_register/register_frame.jsp?car_mng_id="+fm.c_id.value+"&rent_mng_id="+fm.m_id.value+"&rent_l_cd="+fm.l_cd.value;
			}
			else if(idx == '24'){
				if(fm.c_id.value != "")				
					url = "/acar/cus0401/cus0401_d_sc_carinfo.jsp?car_mng_id="+fm.c_id.value+"&rent_mng_id="+fm.m_id.value+"&rent_l_cd="+fm.l_cd.value;
			}			
/*			else if(idx == '14') url = "/acar/con_ser/service_u.jsp";						
			else if(idx == '21') url = "/acar/car_service/service_i_frame.jsp?mode=2";				
			else if(idx == '22') url = "/acar/car_accident/car_accid_i_frame.jsp?cmd=u";	*/
			else return;		
		}
//		if(fm.m_id.value == ""){ alert("��������ȣ�� �����ϴ�."); return; }
//		if(fm.l_cd.value == ""){ alert("����ȣ�� �����ϴ�."); return; }
		fm.auth_rw.value = '';					
		fm.action = url;				
		fm.target = 'd_content';	
		fm.submit();						
	}			
//-->
</script>
</head>

<body onLoad="javascript:locationUrl()" STYLE="background-color:=#F0FDFF">
<form action='con_reg_hi_u_a.jsp' name="form1" method='post'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='client_id' value=''>
<input type='hidden' name='auth_rw' value=''>
<input type='hidden' name='user_id' value=''>
<input type='hidden' name='br_id' value=''>
<input type='hidden' name='accid_id' value=''>
<input type='hidden' name='serv_id' value=''>
<input type='hidden' name='seq_no' value=''>
<table width=100% height=100% bgcolor=#F0FDFF>
  <tr>					
 	<td align="center" valign="middle"> 
	<%if(!(dept_id.equals("8888")||(dept_id.equals("0999")) )){%>
        <select name="gubun1" onChange="javascript:page_move()">
          <option value="">:::: �ٷΰ��� ::::</option>		
          <option value="00">==��������==</option>
          <option value="20">������</option>
          <option value="23">�ڵ�������</option>		  
          <option value="01">==�繫ȸ��==</option>
          <option value="1">�뿩��</option>
          <option value="2">������</option>
          <option value="3">���·�(��)</option>
          <option value="4">��å��</option>
          <option value="5">��/������</option>
          <option value="6">�ߵ�����</option>
          <option value="7">�̼�������</option>
          <option value="8">�Һα�</option>
          <option value="9">�����</option>
          <option value="10">���·�(��)</option>
          <option value="14">�����</option>		  
          <option value="11">���޼�����</option>																
          <option value="12">��Ÿ���</option>		
          <option value="13">Ư�Ҽ�</option>		
          <option value="03">==������==</option>		  		 
          <option value="22">������</option>
          <option value="02">==������==</option>
          <option value="24">�ڵ�������</option>
        </select>	
	<%}%>	
	</td>
  </tr>		
</table>

</body>
</html>
