<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%

String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"4":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	Vector users = c_db.getUserList("", "", "EMP"); //��������� ����Ʈ
	int user_size = users.size();	
	Vector users2 = c_db.getUserList("9999", "", "", "N"); //����� ����Ʈ
	int user_size2 = users2.size();
	Vector users3 = c_db.OutCarJCList(); //�ڵ��� ����� ����Ʈ
	int user_size3 = users3.size();
	String idx_gubun = request.getParameter("idx_gubun")==null?"":request.getParameter("idx_gubun");
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script language="JavaScript">
<!--
	function search()
	{
		document.form1.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	

	//���÷��� Ÿ��-��з�
	function cng_input(){
		var fm = document.form1;
		if(fm.gubun6.options[fm.gubun6.selectedIndex].value == '6'){ //�Ⱓ
			td_e1.style.display	= '';
			
		}else{
			td_e1.style.display	= 'none';
			
		}
	}	

//���÷��� Ÿ��-�ߺз�
	function cng_input1(){
		var fm = document.form1;
		if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '8'){ //�����/��ȣ
			td_a1.style.display	= 'none';
			td_b1.style.display	= 'none';
			td_c1.style.display	= 'none';
			td_d1.style.display	= '';
		}else if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '9'){ //��������
			td_a1.style.display	= '';
			td_b1.style.display	= 'none';
			td_c1.style.display	= 'none';
			td_d1.style.display	= 'none';
		}else if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '10'){ //���������
			td_a1.style.display	= 'none';
			td_b1.style.display	= '';
			td_c1.style.display	= 'none';
			td_d1.style.display	= 'none';
		}else if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '11'){ //�����(�ڵ���)
			td_a1.style.display	= 'none';
			td_b1.style.display	= 'none';
			td_c1.style.display	= '';
			td_d1.style.display	= 'none';
		}else{			
			td_a1.style.display	= 'none';
			td_b1.style.display	= 'none';
			td_c1.style.display	= 'none';
			td_d1.style.display	= 'none';
		}
	}	
	
	//���� ������ ����Ʈ �̵�
	function list_move()
	{
		var fm = document.form1;
		var url = "";
		fm.auth_rw.value = "";		
		fm.gubun4.value = "";		
		var idx = fm.gubun1.options[fm.gubun1.selectedIndex].value;
		if(idx == '1') 		url = "/fms2/out_car/out_car_frame_a.jsp";
		else if(idx == '2') url = "/fms2/out_car/out_car_frame_b.jsp";
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}				
		
//-->
</script>
</head>
<body>
<form name='form1' method='post' action='/fms2/out_car/out_car_sc.jsp' target='c_body'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='idx_gubun' value='<%=idx_gubun%>'>
<table border=0 cellspacing=0 cellpadding=0 width='100%'>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������� > <span class=style5>��ü�����Ȳ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>
            <table border='0' cellspacing='1' cellpadding='0' width='100%'>
            	<tr>
					<td width="10%">&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
						<select name='gubun1' onChange="javascript:list_move()">
							<option value="0">����</option>
							<option value="1">�Ⱓ</option>
							<option value="2" selected >��Ī</option>
						</select>
					</td>
					<td id=''>	
					    <select name="gubun7">
							<option value=""  <%if(gubun7.equals(""))%>selected<%%>>�����</option>
							<option value="2" <%if(gubun7.equals("2"))%>selected<%%>>�����</option>
						</select>
						&nbsp;
						<select name="gubun6" onChange="javascript:cng_input()">
							<option value="1" <%if(gubun6.equals("1"))%>selected<%%>>��ü</option>
							<option value="6" <%if(gubun6.equals("6"))%>selected<%%>>�Ⱓ</option>
							<option value="3" <%if(gubun6.equals("3"))%>selected<%%>>����</option>
							<option value="4" <%if(gubun6.equals("4"))%>selected<%%>>���</option>
						</select>
					</td>
					<td id='td_e1' width="" <%if(gubun6.equals("2")){%> style="display:''"<%}%>>	
						<input type='text' name='t_st_dt' size='11' class='text' value='' onClick='javascript:document.form1.dt[2].checked=true;'> 
							~
						<input type='text' name='t_end_dt' size='11' class='text' value='' onClick='javascript:document.form1.dt[2].checked=true;'>
					</td>
					<td>
						<select name="gubun2" onChange="javascript:cng_input1()">
							<option value="7" <%if(gubun2.equals("7"))%>selected<%%>>�Ⱓ��ü</option>
							<option value="8" <%if(gubun2.equals("8"))%>selected<%%>>�����/��ȣ</option>
							<option value="9" <%if(gubun2.equals("9"))%>selected<%%>>��������</option>
							<option value="10" <%if(gubun2.equals("10"))%>selected<%%>>���������</option>
							<option value="11" <%if(gubun2.equals("11"))%>selected<%%>>�����(�ڵ���)</option>
						</select>
					</td>
					<td id='td_a1' width="" <%if(gubun2.equals("9")){%> style='display:none'<%}%>>	
						<select name="gubun3">
							<option value="S1" <%if(gubun3.equals("S1"))%>selected<%%>>����</option>
							<option value="B1" <%if(gubun3.equals("B1"))%>selected<%%>>�λ�����</option>
							<option value="D1" <%if(gubun3.equals("D1"))%>selected<%%>>��������</option>
							<option value="S2" <%if(gubun3.equals("S2"))%>selected<%%>>��������</option>
							<option value="S3" <%if(gubun3.equals("S3"))%>selected<%%>>��������</option>
							<option value="S4" <%if(gubun3.equals("S4"))%>selected<%%>>��������</option>
							<option value="S5" <%if(gubun3.equals("S5"))%>selected<%%>>��ȭ������</option>
							<option value="S6" <%if(gubun3.equals("S6"))%>selected<%%>>��������</option>
							<option value="G1" <%if(gubun3.equals("G1"))%>selected<%%>>�뱸����</option>
							<option value="J1" <%if(gubun3.equals("J1"))%>selected<%%>>��������</option>
							<option value="I1" <%if(gubun3.equals("I1"))%>selected<%%>>��õ����</option>
							<option value="K1" <%if(gubun3.equals("K3"))%>selected<%%>>��������</option>
							<option value="U1" <%if(gubun3.equals("U1"))%>selected<%%>>�������</option>
						</select>
					</td>
					<td id='td_b1' width="" <%if(gubun2.equals("10")){%> style='display:none'<%}%>>	
						<select name='gubun4'>
						  <option value="">������</option>
						  <%	if(user_size > 0){
							for (int i = 0 ; i < user_size ; i++){
								Hashtable user = (Hashtable)users.elementAt(i);	%>
						  <option value='<%=user.get("USER_ID")%>' <%if(t_wd.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
						  <%		}
						}		%>
						<option value="">=�����=</option>
						  <%if(user_size2 > 0){
								for (int i = 0 ; i < user_size2 ; i++){
									Hashtable user2 = (Hashtable)users2.elementAt(i);	%>
						  <option value='<%=user2.get("USER_ID")%>' <%if(t_wd.equals(user2.get("USER_ID"))) out.println("selected");%>><%=user2.get("USER_NM")%></option>
						  <%	}
							}%>
						</select>
					</td>
					<td id='td_c1' width="" <%if(gubun2.equals("11")){%> style='display:none'<%}%>>	
						<select name='gubun5'>
						  <option value='0'>��ü</option>
						  <%	if(user_size3 > 0){
							for (int i = 0 ; i < user_size3 ; i++){
								Hashtable user3 = (Hashtable)users3.elementAt(i);	%>
						  <option value='<%=user3.get("PO_ITEM")%>' <%if(t_wd.equals(user3.get("PO_ID"))) out.println("selected");%>><%=user3.get("PO_NM")%></option>
						  <%		}
						}		%>
						</select>
					</td>
					<td id='td_d1' width="" <%if(gubun2.equals("8")){%> style='display:none'<%}%>>	
						�˻�:<input type='text' name='t_wd' size='15' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
					</td>	
					<td>
						<a href='javascript:search()'><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>
					</td>
				</tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>