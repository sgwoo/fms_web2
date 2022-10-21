<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.tint.*, acar.car_office.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "17", "08", "10");	
	
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Hashtable car = new Hashtable();
	
	if(!car_mng_id.equals(""))	car = t_db.getUseLcCont(car_mng_id, "");
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	CodeBean[] codes = c_db.getCodeAll("0015");
	int c_size = codes.length;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	

	//��ǰ��ü ��ȸ
	function search_off()
	{
		var fm = document.form1;	
		window.open("/acar/cus0601/cus0603_frame.jsp?from_page=/fms2/tint/tint_reg_step1.jsp&t_wd="+fm.off_nm.value, "SERV_OFF", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//��ǰ��ü ����
	function view_off()
	{
		var fm = document.form1;
		if(fm.off_id.value == ""){ alert("���õ� ��ǰ��ü�� �����ϴ�."); return;}
		window.open("/acar/cus0601/cus0603_d_frame.jsp?from_page=/fms2/consignment/cons_i_c.jsp&off_id="+fm.off_id.value, "SERV_OFF", "left=10, top=10, width=900, height=260, scrollbars=yes, status=yes, resizable=yes");
	}		
		
	//�ڵ��� ��ȸ
	function search_car()
	{
		var fm = document.form1;
		window.open("/tax/pop_search/s_car.jsp?go_url=/fms2/tint/tint_reg_step1.jsp&s_kd=2&t_wd="+fm.car_no.value, "CAR", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//�ڵ��� ����
	function view_car()
	{
		var fm = document.form1;
		if(fm.off_id.value == ""){ alert("���õ� ��ǰ��ü�� �����ϴ�."); return;}
		if(fm.car_mng_id.value == ""){ alert("���õ� �ڵ����� �����ϴ�."); return;}	
		window.open("/acar/car_register/car_view.jsp?rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value+"&car_mng_id="+fm.car_mng_id.value+"&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}			

	//��ǰ���п� ���� ����
	function cng_input(){
		var fm = document.form1;
		
		if(fm.tint_st.checked == true){
			tr_tint_1.style.display	= '';
			tr_tint_2.style.display	= '';
			tr_tint_3.style.display	= 'none';			
		}
			
	
	}	
	
	function save(){
		var fm = document.form1;
		
		if(fm.off_id.value == "")			{ 	alert("���õ� ��ǰ��ü�� �����ϴ�."); 	return;	}
		if(fm.req_id.value == "")			{ 	alert("�Ƿ��ڸ� �Է��Ͻʽÿ�."); 		return;	}	
	
		if(fm.tint_st[0].checked == true){
			if(fm.car_no.value == "") 		{ 	alert("���õ� ������ �����ϴ�. ������ȣ�� ������ �����ȣ�� ���� �Է��ϼ���");	return;	}
			if(fm.rent_l_cd.value == "") 	{ 	alert("������ȸ�� ���� �ʾҽ��ϴ�.");	return;	}
			if(fm.film_st[0].checked == false && fm.film_st[1].checked == false && fm.film_st[2].checked == false && fm.film_st[3].checked == false)
											{ 	alert("�ʸ������� �����Ͻʽÿ�.");		return;	}
		}
		
	//	if(fm.tint_st[0].checked == true){
	//		if(fm.car_no.value == "") 		{ 	alert("���õ� ������ �����ϴ�. ������ȣ�� ������ �����ȣ�� ���� �Է��ϼ���");	return;	}
	//		if(fm.rent_l_cd.value == "") 	{ 	alert("������ȸ�� ���� �ʾҽ��ϴ�.");	return;	}
	//		if(fm.film_st[0].checked == false && fm.film_st[1].checked == false && fm.film_st[2].checked == false && fm.film_st[3].checked == false)
	//										{ 	alert("�ʸ������� �����Ͻʽÿ�.");		return;	}
	//	}
		
		if(fm.cleaner_st[0].checked == false && fm.cleaner_st[1].checked == false)
											{ 	alert("û�ҿ�ǰ ������ �����Ͻʽÿ�.");	return;	}
		if(fm.sup_est_dt.value == ''){	alert('�۾�������û�Ͻø� �Է��Ͽ� �ֽʽÿ�.');		fm.sup_est_dt.focus(); 		return;		}
		
		if(confirm('����Ͻðڽ��ϱ�?')){		
			fm.action='tint_reg_step1_a.jsp';
			fm.target='i_no';
//			fm.target='d_content';
			fm.submit();
		}		
	}
	
	function enter(nm) {
		var keyValue = event.keyCode;
		if (keyValue =='13') {
			if(nm == 'car_no')	search_car();
		}
	}	

//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='' name="form1" method='post'>
 <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
 <input type='hidden' name='user_id' value='<%=user_id%>'>
 <input type='hidden' name='br_id' value='<%=br_id%>'>
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>���¾�ü > ��ǰ���� ><span class=style5>��ǰ�Ƿڵ��</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 
    <tr>
        <td class=line2></td>
    </tr> 
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' class='title'>��ǰ��ü</td>
                    <td>&nbsp;
        			  <input type='text' name="off_nm" value='' size='30' class='text'>
        			  <input type='hidden' name='off_id' value=''>
        			  <span class="b"><a href="javascript:search_off()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
        			  <span class="b"><a href="javascript:view_off()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_see.gif"  border="0" align=absmiddle></a></span>
        			</td>
                    <td width='13%' class='title'>�Ƿ���</td>
                    <td width="37%">&nbsp;
                      <select name='req_id'>
                        <option value="">����</option>
                        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}%>
                      </select></td>			
                </tr>
                <tr> 
                    <td width='13%' class='title'>�Ƿڱ���</td>
                    <td colspan='3'>&nbsp;
        			  <input type='radio' name="tint_st" value='1' onClick="javascript:cng_input()" checked>
        				��������ǰ�Ƿ�
        			  <input type='radio' name="tint_st" value='2' onClick="javascript:cng_input()">
        				�뷮��ǰ�Ƿ� (��: �������� ��ġ�� û����)
        			</td>		  
                </tr>
            </table>
        </td>
    </tr>
	<tr>
	    <td></td>
	</tr>
	<tr>
	    <td style='background-color:e5e5e5; height:1'></td>
	</tr>
	<tr>
	    <td></td>
	</tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ǰ��û����</span></td>
	</tr>
    <tr id=tr_tint_1 style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr><td class=line2 style='height:1'></td></tr>
                <tr> 
                    <td width='13%' class='title'>������ȣ/�����ȣ</td>
                    <td width='37%'>&nbsp;
        			  <input type='text' name="car_no" value='' size='30' class='text' onKeyDown="javasript:enter('car_no')">
        			  <input type='hidden' name='car_mng_id' value=''>
        			  <input type='hidden' name='rent_mng_id' value=''>
        			  <input type='hidden' name='rent_l_cd' value=''>
        			  <input type='hidden' name='client_id' value=''>
        			  <span class="b"><a href="javascript:search_car()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
        			</td>
        			<td width='13%' class='title'>����</td>
        			<td width='37%'>&nbsp;
    			    <input type='text' name="car_nm" value='' size='40' class='whitetext' readonly></td>
                </tr>
    		    <tr>
        		    <td class='title'>����</td>
        			<td>&nbsp;
        			  <input type='text' name="car_y_form" value='' size='40' class='whitetext' readonly>
        			</td>
        		    <td class='title'>����</td>
        			<td>&nbsp;
    			    <input type='text' name="color" value='' size='40' class='whitetext' readonly></td>			
    		    </tr>
    		    <tr>
        		    <td class='title'>����</td>
        			<td colspan="3">&nbsp;
        			  <input type='text' name="firm_nm" value='' size='70' class='whitetext' readonly>
        			</td>
    		    </tr>
		    </table>
	    </td>
    </tr>
	<tr id=tr_tint_2 style="display:''">
	    <td>&nbsp;</td>
	</tr>
    <tr>
        <td class=line2></td>
    </tr>  	
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td colspan="2" class=title>����</td>
                    <td colspan="2" class=title>û�ҿ�ǰ</td>
                </tr>
                <tr>
                    <td width="13%" class=title>�ʸ�����</td>
                    <td width="37%" >&nbsp;
        			  <input type='radio' name="film_st" value=''>
        				����
        			  <input type='radio' name="film_st" value='1'>
        				�Ϲ�
        			  <input type='radio' name="film_st" value='2'>
        				3M
        			  <input type='radio' name="film_st" value='3'>
        				�縶
        			</td>
                    <td width="13%" class=title>�⺻</td>
                    <td width="37%">&nbsp;
        			  <input type='radio' name="cleaner_st" value='1'>
        				����
        			  <input type='radio' name="cleaner_st" value='2'>
        				����
                    </td>
                </tr>
                <tr>
                    <td class=title>���ñ���������</td>
                    <td>&nbsp;
        			  <input type='text' name='sun_per' size='3' value='' class='default' >%
        			</td>
                    <td class=title>�߰�</td>
                    <td>&nbsp;
                        <input type='text' name='cleaner_add' size='40' value='' class='default' >
                    </td>
                </tr>
                <tr> 
                    <td colspan="2" class=title>�׺���̼�</td>
                    <td colspan="2" class=title>��Ÿ</td>
                </tr>
                <tr>
                    <td width="10%" class=title>��ǰ��</td>
                    <td>&nbsp;
                        <input type='text' name='navi_nm' size='45' value='' class='default' >
                    </td>
                    <td colspan="2" rowspan="2">&nbsp;
    			    <textarea name="sup_other" cols="55" rows="4" class="default"></textarea></td>
                </tr>
                <tr>
                    <td class=title>(����)����</td>
                    <td>&nbsp;
                        <input type='text' name='navi_est_amt' maxlength='10' value='' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
                        �� </td>
                </tr>
                <tr>
                    <td class=title>���ڽ�</td>
                    <td colspan="3">&nbsp;
        			  <input type='radio' name="blackbox_yn" value='N'>
				    ������
				    <input type='radio' name="blackbox_yn" value='Y'>
				    ����
        			</td>
                </tr>
                <tr>
                    <td class=title>����</td>
                    <td colspan="3">&nbsp;
        			  <textarea name="sup_etc" cols="105" rows="4" class="default"></textarea>
        			</td>
                </tr>
                <tr>
                    <td class=title style='height:36'>�۾�����<br>��û�Ͻ�</td>
                    <td colspan="3">&nbsp;
        			  <input type='text' size='11' name='sup_est_dt' maxlength='10' class='default' value='' onBlur='javscript:this.value = ChangeDate(this.value);'>
        			  <input type='text' size='2' name='sup_est_h' class='default' value='' maxlength='2'>��
        			</td>
                </tr>	
    		</table>
	    </td>
	</tr> 		
	<tr id=tr_tint_3 style='display:none'>
	    <td><font color=#666666>&nbsp;�� û���Դ뷮�����϶��� <b>����</b>���� <b>���Լ���</b>�� �����ֽʽÿ�. (��: û���� 40��)</font></td>
	</tr>							
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>				
	 <%if( auth_rw.equals("4") || auth_rw.equals("6")) {%>
	 <tr>
	    <td align="center">&nbsp;<a href="javascript:window.save();"><img src="/acar/images/center/button_reg.gif"  border="0" align=absmiddle></td>
	</tr>
	<% } %>		
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>				
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	var fm = document.form1;	
//-->
</script>
</body>
</html>