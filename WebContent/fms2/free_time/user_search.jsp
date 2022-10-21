<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.free_time.*"%>
<jsp:useBean id="ft_db" scope="page" class="acar.free_time.Free_timeDatabase"/>


<%
	String go_url 	= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String nm = request.getParameter("nm")==null?"":request.getParameter("nm");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String use_yn = request.getParameter("use_yn")==null?"Y":request.getParameter("use_yn");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String title1 = request.getParameter("title1")==null?"":request.getParameter("title1");
	String gubun ="";
	
	Vector users = new Vector();
	
	// ���� �Ⱥ���, ���� ��ä��, ���� �豤��,  ���� ������
	if(user_id.equals("000004")||user_id.equals("000005")||user_id.equals("000026") ||user_id.equals("000028")){
		gubun = "chief";
	}else{ // ������ ������ ���� ������û�� �ش� �μ� ������ �����ֱ�
		gubun = dept_id;
	}
		
	users = ft_db.free_work_id2(st_dt, end_dt, gubun, user_id);

	int user_size = users.size();
		
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.action="user_search.jsp";
		fm.submit();
	}
	function setCode(work_id, name){
		var fm = document.form1;	
		
		opener.form1.user_nm.value 				= name;		
		opener.form1.work_id.value 				= work_id;		
		
		window.close();
	}
	
//-->
</script>
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>

</head>
<body>
<form action="./user_search.jsp" name="form1" method="POST">
	<input type='hidden' name='nm' value='<%=nm%>'>
	<input type="hidden" name="go_url" value="<%=go_url%>">
	<input type="hidden" name="dept_id" value="<%=dept_id%>">
	<input type="hidden" id="user_id" name="user_id" value="<%=user_id%>">
	<table border=0 cellspacing=0 cellpadding=0 width=100%>
		<tr>
	    	<td class=h></td>
		</tr>
		<tr>
	        <td>�ؿ����� ������ ��ü�ٹ��ڷ� ���� �Ұ��� �մϴ�.</td>
	    </tr>
		<tr>
	        <td class=h></td>
	    </tr>
	    <tr>
	        <td class=line2></td>
	    </tr>
		<tr>
			<td class="line" >
				<table border="0" cellspacing="1" cellpadding="0" width='100%'>
			          <tr>
			            <td width='10%' class='title'>����</td>
			            <td width='20%' class='title'>�ڵ�</td>
						<td width='20%' class='title'>�μ�</td>
			            <td width='25%' class='title'>�̸�</td>
						<td width='25%' class='title'>����</td>
			          </tr>
			          <%if(user_size > 0){
							for (int i = 0 ; i < user_size ; i++){
								Hashtable ht = (Hashtable)users.elementAt(i);%>			
			          <tr>
			            <td align="center"><%=i+1%></td>
			            <td align="center"><%=ht.get("USER_ID")%></td>
						<td align="center"><%=ht.get("DEPT_NM")%></td>
			            <td align="center">
			               <%if(!ht.get("DAY").equals("")){%>
			               <%	if(ht.get("TITLE").equals("��������") && title1.equals("���Ĺ���")){%>
			                   <a href="javascript:setCode('<%=ht.get("USER_ID")%>','<%=ht.get("USER_NM")%>')"><%=ht.get("USER_NM")%></a>
			               <%	}else if(ht.get("TITLE").equals("���Ĺ���") && title1.equals("��������")){%>
			                   <a href="javascript:setCode('<%=ht.get("USER_ID")%>','<%=ht.get("USER_NM")%>')"><%=ht.get("USER_NM")%></a>    
			               <%	}else{%>
			                   <%=ht.get("USER_NM")%>			               
			               <%	}%>    
			               <%}else{%>
			                   <a href="javascript:setCode('<%=ht.get("USER_ID")%>','<%=ht.get("USER_NM")%>')"><%=ht.get("USER_NM")%></a>
			               <%}%>
			            </td>
						<td align="center"><%if(!ht.get("DAY").equals("")){%><%=ht.get("SCH_CHK")%>-<%=ht.get("TITLE")%><%}%> </td>
			          </tr>
					  <%	}%>
					  <%}else{%>
			          <tr>		  
			            <td colspan="5" align="center">��ϵ� ����Ÿ�� �����ϴ�.</td>
			          </tr>
					  <%}%>		  
				</table>
			</td>
		</tr>
		<tr>
        	<td><hr></td>
    	</tr>
		<tr>
			<td class=h></td>
		</tr>
		<tr>
			<td>
				<img src="/acar/images/center/arrow_sm.gif" style="vertical-align:middle;">&nbsp;<input id="t_wd" name="t_wd" type="text" class="text" value="" size="20" style='IME-MODE: active'
					>&nbsp;<a href="#" id="searBtn"><img src="/acar/images/center/button_search.gif" border=0 style="vertical-align:middle;"></a>
			</td>
		</tr>
		<tr>
        	<td class=h></td>
    	</tr>
		<tr>
			<td id="searchTableTd">
				<table id="searchTable" border="0" cellspacing="1" cellpadding="0" width='100%'></table>
			</td>
		</tr>
		<tr>
			<td align="right"><a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a></td>
		</tr>
	</table>
</form>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
	<script>
		// �˻���ư Ŭ�� �̺�Ʈ
		$("#searBtn").click(function(){
			getSearch();
		});
		
		// ����Ű ó��
		$("input[type='text']").keydown(function (){
			if(event.keyCode === 13){
				event.preventDefault();// ����Ű submit ����
				getSearch();
			}
		});
	
		// ���̺� �׸���
		function setTable(jsonData){
			$("#searchTableTd").addClass("line");	// �˻��� ���ÿ� line Ŭ������ �־��ش�
			$("#searchTable").empty();
			$("#searchTable").html('<tr>'+
													'<td class="title" style="width:10%;">����</td>'+
													'<td class="title" style="width:20%;">�ڵ�</td>'+
													'<td class="title" style="width:20%;">�μ�</td>'+
													'<td class="title" style="width:25%;">�̸�</td>'+
													'<td class="title" style="width:25%;">����</td>'+
												'</tr>');
			if(jsonData.length > 0){
				var loginUserId = $("#user_id").val();
				$.each(jsonData, function(i, v){
					if(loginUserId == v.USER_ID){	// �ڽ��� �˻� �� ���
						if(jsonData.length == 1){		// �˻� ����� 1���� ��� �����Ͱ� ���� ������ ���
							$("#searchTable").append('<tr>'+
							'<td colspan="5" align="center">��ϵ� ����Ÿ�� �����ϴ�.</td>');
						}
					}
					if(loginUserId != v.USER_ID){	// �ڽ��� ����Ʈ�� ��µ��� �ʵ��� �Ѵ�
						$("#searchTable").append('<tr>'+
								'<td align="center">'+(i+1)+'</td>'+
								'<td align="center">'+v.USER_ID+'</td>'+
								'<td align="center">'+v.BR_NM+'</td>'+
								'<td align="center"><a href="javascript:setCode(\''+v.USER_ID+'\',\''+v.USER_NM+'\')">'+v.USER_NM+'</a></td>'+
								'<td align="center"></td>'+
							'</tr>');
					}
				});
			}else {
				$("#searchTable").append('<tr>'+
															'<td colspan="5" align="center">��ϵ� ����Ÿ�� �����ϴ�.</td>');
			}
		}
		
		// ajax �񵿱� ���
		function getSearch(){
			var name = $("#t_wd").val();// ����
			$.ajaxSettings.traditional = true;
			$.ajax({
				type			: "POST",
				url				: "/fms2/free_time/user_search_a.jsp",
				dataType	: "text",
				data			: {
					'name':name
				},
				//async:false,
				contentType: "application/x-www-form-urlencoded; charset=UTF-8",
				error			: function(){
					alert("fail");
				},
				success		: function(data){					
					var jsonArray = JSON.parse(data);
					var jsonData = jsonArray["vt"];
					setTable(jsonData);	// ������� �����͸� ���̺� �׷��ش�
				}
			});
		}

	</script>
</body>
</html>

