<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�ϰ�����ϱ�
	function card_all_del(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					idnum=ck.value;
					cnt++;					
				}
			}
		}	
		
		if(cnt == 0){
		 	alert("1���̻� �����ϼ���.");
			return;
		}	
		
		//fm.target = "i_no";
		fm.target = "_blank";
		fm.action = "card_all_del.jsp";
		fm.submit();	
	}			

	//�ϰ������ϱ�
	function card_all_upd(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					idnum=ck.value;
					cnt++;					
				}
			}
		}	
		
		if(cnt == 0){
		 	alert("1���̻� �����ϼ���.");
			return;
		}	
		
		//fm.target = "i_no";
		fm.target = "_blank";
		fm.action = "card_all_upd.jsp";
		fm.submit();	
	}				
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	int cnt = 4; //��Ȳ ��� ������ �Ѽ�
	//if(cnt > 0 && cnt < 5) cnt = 5; //�⺻ 
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*25)-245;//��Ȳ ���μ���ŭ ���� ���������� ������
%>
<form name='form1' action='client_mng_c.jsp' method='post' target='t_content'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='client_id' value=''>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='reg_gu' value='1'>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
  <tr>
	  <td>
	  <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("����ī�������",user_id) || nm_db.getWorkAuthUser("����ī���ü��",user_id)){%>
	  <a href="javascript:card_all_del();" title='�ϰ����'><img src=/acar/images/center/button_igpg.gif border=0 align=absmiddle></a> 
	  &nbsp;&nbsp;&nbsp;&nbsp;
	  <a href="javascript:card_all_upd();" title='�ϰ�����'><img src=/acar/images/center/button_modify_ig.gif border=0 align=absmiddle></a> 
	  <%}%>
	  </td>
	</tr>    
    <tr> 
      <td height="<%=height%>"><iframe src="card_mng_sc_in.jsp<%=hidden_value%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
        </iframe> </td><!--����ͳ��� - sh ���� - ��ܸ޴� ���� - (���μ�*40)-->
    </tr>  
</table>
</form>
</body>
</html>