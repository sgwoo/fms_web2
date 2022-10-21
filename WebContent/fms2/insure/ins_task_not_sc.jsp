<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 1; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
			"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+
		  "&sh_height="+height+"&st_dt="+st_dt+"&end_dt="+end_dt+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"";
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
	//선택메일발송
	function select_email(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}			
		if(cnt == 0){
		 	alert("차량을 선택하세요.");
			return;
		}	
		
		//fm.target = "_blank";
		fm.target = "i_no";
		fm.action = "/fms2/insure/select_send_mail_task.jsp";
		fm.submit();	

	}	
	
	//반영버튼 클릭시
	function select_save(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}			
		if(cnt == 0){
		 	alert("차량을 선택하세요.");
			return;
		}	
		
		 window.open("" ,"popForm",
		       "toolbar=no, width=1200, height=1067, directories=no, status=no,    scrollorbars=no, resizable=no");
		 fm.action ="/fms2/insure/ins_task_not_a.jsp";
		 fm.method="post";
		 fm.target="popForm";
		 fm.submit();
		
	}
</script>

<style>
	   #saveBtn{   background-color: #6d758c;
				font-size: 12px;cursor: pointer;
				border-radius: 2px;color: #fff;
				border: 0; outline: 0;
				padding: 5px 8px; margin: 3px;
				width:200px;height:25px;
				
			}
</style>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin="10">

<form name='form1' method='post' target='d_content' action='ins_com_emp_not_sc.jsp'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			  
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>  
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/insure/ins_com_emp_not_frame.jsp'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    
    
    <tr>
    	 <td style="padding-bottom: 20px;">
	    	<input type="button" value="보험배서 등록 요청" id="saveBtn" onclick="javascript:select_save();">
	    </td>
    </tr>
    
    <tr>
  
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>총 <input type='text' name='size' value='' size='4' class=whitenum> 건</span>
	    &nbsp;&nbsp;&nbsp;&nbsp;	    
	    <a href="javascript:select_email();" title='선택 메일발송하기'><img src=/acar/images/center/button_send_smail.gif align=absmiddle border=0></a>	
	    (세금계산서 이메일 수신자에게 발송됨)&nbsp;&nbsp;<b>※사업자번호에 색상으로 표기된 건은 1대 이상의 차량을 이용하는 고객입니다.</b>   	    
	</td>
    </tr>
    <tr>
	<td>
	    <table border="0" cellspacing="0" cellpadding="0" width=100%>
		<tr>
		    <td>
			<iframe src="ins_task_not_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
			</iframe>
		    </td>
		</tr>
	    </table>
	</td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
