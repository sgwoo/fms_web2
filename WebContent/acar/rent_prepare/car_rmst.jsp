<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*,  acar.user_mng.*,  acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ page import="acar.car_check.*"%>
<jsp:useBean id="cc_db" scope="page" class="acar.car_check.Car_checkDatabase"/>
<%//@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_cd 	= request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String car_no 	= request.getParameter("car_no")==null?"":request.getParameter("car_no");	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
		
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//�α���ID&������ID&����
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "04", "01");
	
	//��������
	Hashtable res = rs_db.getCarInfo(c_id);	
	
	Hashtable ht = cc_db.getCarInfo(c_id);
	
	Hashtable car = cc_db.getCar_Standard();
	
	//������Ȳ
	Vector check = cc_db.getCheck_list(c_id);
	int check_size = check.size();	
	String check_no ="";
%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
	//�����ϱ�
	function save(){
		var fm = document.form1;
		if(fm.rm_cont.value == ''){ alert('�󼼳����� �Է��Ͻʽÿ�.'); return; }
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
		fm.action = 'car_rmst_a.jsp';
		fm.target = 'i_no';
		fm.submit();			
	}
	

	function search2(){//�������� ������ �������� ���
		var fm = document.form1;		
		fm.action = "/fms2/car_check/check_view.jsp";
		fm.target='_blank';
		fm.submit();
	}
	
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
</script>
</head>
<body leftmargin="15" onLoad="javascript:document.form1.rm_st.focus()">
<form action="" name="form1" method="post" >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' 	value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_cd' 	value='<%=s_cd%>'>
<input type='hidden' name='c_id' 	value='<%=c_id%>'>
<input type='hidden' name='car_no' 	value='<%=car_no%>'>

<table border=0 cellspacing=0 cellpadding=0 width=400>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=car_no%>(<%=c_id%>) ���� ����
		<%//if(user_id.equals("000026")||user_id.equals("000096")){%> 
		<a  href="javascript:MM_openBrWindow('http://fms1.amazoncar.co.kr/fms2/car_standard/car_standard.jsp?user_id=<%=user_id%>','car_standard','scrollbars=no,status=yes,resizable=yes,width=420,height=350,left=50, top=50')">
						[���˱��ؼ���]
						</a>
		<%//}%>
						</span>        
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="20%">����</td>
                    <td>
						<SELECT NAME="rm_st" >
							<option value=""  <%if( res.get("RM_ST").equals(""))%> selected<%%>>����</option>                      		  
							<option value="3" <%if( res.get("RM_ST").equals("3"))%> selected<%%>>�����</option>
							<option value="9" <%if( res.get("RM_ST").equals("9"))%> selected<%%>>�̵���</option>
							<option value="4" <%if( res.get("RM_ST").equals("4"))%> selected<%%>>A��</option>
							<option value="7" <%if( res.get("RM_ST").equals("7"))%> selected<%%>>B��</option>
							<option value="8" <%if( res.get("RM_ST").equals("8"))%> selected<%%>>C��</option>
						</SELECT>
						<%if(check_size > 0){%>
						<select name="check_no">
							<%		
								for(int i = 0 ; i < check_size ; i++){
									Hashtable ht2 = (Hashtable)check.elementAt(i); 
							%>		
							<option value="<%=ht2.get("CHECK_NO")%>"><%=AddUtil.ChangeDate2(String.valueOf(ht2.get("REG_DT")))%></option>		
							<%	check_no = String.valueOf(ht2.get("CHECK_NO"));
							}%>
						</select>
							&nbsp;&nbsp;<a href="javascript:search2()"><img src=/acar/images/center/button_see.gif align=absmiddle border=0></a>  
		
						<%}%>
					</td>
				</tr>    		
                <tr> 
                    <td class=title>�󼼳���</td>
                    <td> 
                        <textarea name="rm_cont" cols="40" class="text" rows="8"><%=res.get("RM_CONT")%></textarea>
                    </td>
                </tr>        
                 <tr> 
					<td class='title' width=20%>������</td>
					<td>
					
						<select name="checker">
						<% if(res.get("CHECKER").equals("000217")){%>
							<option value='' >=���¾�ü=</option>
							<option value='000217' selected>ȫ��ȣ</option>

							<%if(user_size > 0){
							for(int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i); 
							%>
							<option value='<%=user.get("USER_ID")%>' <% if(res.get("CHECKER").equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option> 
							<%	}
							}%>
						<%}else{%>
							<option value='' >=����=</option>								
							<%if(user_size > 0){
							for(int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i); 
							%>
							<option value='<%=user.get("USER_ID")%>' <% if(res.get("CHECKER").equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option> 
							<%	}
							}%>
							<option value='' >=���¾�ü=</option>
							<option value='000217' >ȫ��ȣ</option>
						<%}%>
						</select>
					</td>
                </tr>  
                <tr> 
                    <td class=title>��������</td>
                    <td> 
                        <%=AddUtil.ChangeDate2(String.valueOf(res.get("CHECK_DT")))%>                        
                    </td>
                </tr>                         
            </table>
        </td>
    </tr>
    <tr> 
        <td>* Ȯ������ �������ڷ� ����30�� ����Ǹ� �ڵ����� ��ҵǾ� ��Ȯ���� �� �ֵ��� �մϴ�.</td>
    </tr>
	<tr> 
        <td class=h></td>
    </tr>
	<tr>
		<td>
		<textarea name="car_stat" cols="60" class="text" rows="17" readonly style="font-size:9pt;border:0;overflow-y:hidden;"><%=car.get("CAR_STAT")%></textarea>	
		</td>
	</tr>
    <tr> 
	
        <td align="right">
		<% 	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
		<a href="javascript:save();"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a> 
		<%}%>
        <a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>
</table>  
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
