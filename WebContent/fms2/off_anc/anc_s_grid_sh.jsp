<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*,acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%	
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
//	String gubun = request.getParameter("gubun")==null?"c_year":request.getParameter("gubun");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<%@ include file="/acar/getNaviCookies.jsp" %>
<style type="text/css">
.span_hidden{	display:none; position: relative; float: left; margin-left: 30px;	}
</style>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language="JavaScript">
$(document).ready(function(){
	//�ʱ� �˻����� �� ����
	setSearchForm();
	
	//�˻����ǿ� ���� �� ����
	$("#gubun1,#gubun2").on("change", function(){
		setSearchForm();												
	}); 
});
function SearchBbs(mode)
{	
	var g_nm = "";
	var selGubun2 = $("#gubun2 option:selected").val();
	if(selGubun2=="period"){	
		var period_st  = $("#period_st").val();
		var period_end = $("#period_end").val();
		if(period_st=="") {	period_st  = "00000000"; }
		if(period_end==""){	period_end = "99999999"; }
		g_nm = period_st + "~" + period_end;
	}
	$("#gubun_1").val($("#content_input").val());
	$("#gubun_2").val(g_nm);
	var theForm = document.BbsSearchForm;
	
	theForm.action = 'anc_s_grid_sc.jsp?gubun_nm='+g_nm+'&gubun3='+mode;
	theForm.target = "c_foot";
	theForm.submit();
}

function setSearchForm(){
	var selGubun1 = $("#gubun1 option:selected").val();
	var selGubun2 = $("#gubun2 option:selected").val();
	
	if(selGubun1==""){	$("#span_1").css("display","none");		}
	else{				$("#span_1").css("display","block");	}
	
	if(selGubun2=="period"){	$("#span_2").css("display","block");	}
	else{						$("#span_2").css("display","none");		}
}

</script>
</head>
<body>
<form action="./anc_s_grid_sc.jsp" name="BbsSearchForm" method="POST" target="c_foot">
	<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
	<input type='hidden' name='br_id' value='<%=br_id%>'>
	<input type='hidden' name='user_id' value='<%=user_id%>'>
	<input type='hidden' name='sh_height' value='<%=sh_height%>'>
	<input type='hidden' name="s_width" value="<%=s_width%>">   
	<input type='hidden' name="s_height" value="<%=s_height%>">  
	<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">  
	<table border=0 cellspacing=0 cellpadding=0 width=100%>
		<tr>
			<td colspan=2>
				<table width=100% border=0 cellpadding=0 cellspacing=0>
					<tr>
						<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
						<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle border=0>&nbsp;<span class=style1>Master > <span class=style5>��������</span></span></td>
						<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td class=h></td>
		</tr>
		<tr>
			<td colspan=2><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ǰ˻�</span></td>
		</tr>
		<tr>
			<td class=line2></td>
		</tr>
		<tr>
			<td class=line>
				<table border="0" cellspacing="1" cellpadding='0' width=100%>
					<tr >
						<td class=title width=10% height="22px">�˻�����</td>
						<td width=*>&nbsp;
							<select name="gubun1" id="gubun1" style="float: left; margin-left: 15px;">
								<option value='' <%if(gubun1.equals("")){%>selected<%}%>>��ü</option>
								<option value='title' <%if(gubun1.equals("title")){%>selected<%}%>>����</option>
								<option value='content' <%if(gubun1.equals("content")){%>selected<%}%>>����</option>
								<option value='user_nm' <%if(gubun1.equals("user_nm")){%>selected<%}%>>�ۼ���</option>
								<option value='keywords' <%if(gubun1.equals("keywords")){%>selected<%}%>>Ű����</option>
							</select>
							<span id="span_1" class="span_hidden"><input type='text' id="content_input" size='30' class='text'></span>&nbsp;&nbsp;
							<!-- �Ⱓ���� ���ǵ��� ���� �и� -->
							<select name="gubun2" id="gubun2" style="float: left; margin-left: 15px;">
								<option value='' <%if(gubun2.equals("")){%>selected<%}%>>��ü</option>
								<option value='c_year' <%if(gubun2.equals("c_year")){%>selected<%}%>>����</option>
								<option value='c_mon' <%if(gubun2.equals("c_mon")){%>selected<%}%>>��� </option>
								<option value='period' <%if(gubun2.equals("period")){%>selected<%}%>>�Ⱓ</option>		<!-- �Ⱓ �߰�(2018.01.24) -->			
							</select>
						<span id="span_2" class="span_hidden"><input type='text' id="period_st" size='15' class='text' placeholder="ex) 2010-01-01"> ~ <input type='text' id="period_end" size='15' class='text' placeholder="ex) 2017-12-31"> (����ϱ���)</span>
						&nbsp;<a href="javascript:SearchBbs('')" style="position: relative;"><img src="/acar/images/center/button_search.gif" align=absmiddle border=0></a>
						&nbsp;&nbsp;<a class="button" style="font-size: 12px; padding:3.5px;" onclick="javascript:SearchBbs('I');">�߿�������� ����</a>
						&nbsp;&nbsp;<a class="button" style="font-size: 12px; padding:3.5px;" onclick="javascript:SearchBbs('M');">���ǰ������� ����</a>
							<input type="hidden" name="gubun_1" id="gubun_1" value=""/>
							<input type="hidden" name="gubun_2" id="gubun_2" value=""/>
						</td>
						<%--td class=title width=10%>ī�װ� �˻�</td>
						<td width=*>&nbsp;
							<INPUT TYPE="radio" NAME="gubun1" value=''  <%if(gubun1.equals("")){%>checked<%}%>>��ü&nbsp;
							<INPUT TYPE="radio" NAME="gubun1" value='1'  <%if(gubun1.equals("1")){%>checked<%}%>>�Ϲݰ���&nbsp;
							<INPUT TYPE="radio" NAME="gubun1" value='4'  <%if(gubun1.equals("4")){%>checked<%}%>>��������&nbsp;
							<INPUT TYPE="radio" NAME="gubun1" value='5'  <%if(gubun1.equals("5")){%>checked<%}%>>������&nbsp;
							<INPUT TYPE="radio" NAME="gubun1" value='6'  <%if(gubun1.equals("6")){%>checked<%}%>>�������λ�&nbsp;
							<INPUT TYPE="radio" NAME="gubun1" value='2'  <%if(gubun1.equals("2")){%>checked<%}%>>�ֱٴ���&nbsp;
							<INPUT TYPE="radio" NAME="gubun1" value='3'  <%if(gubun1.equals("3")){%>checked<%}%>>�Ǹ�����&nbsp;
						</td--%>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>
</body>
</html>  