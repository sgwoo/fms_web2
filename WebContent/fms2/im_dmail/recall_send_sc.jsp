<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String sort_fuel 	= request.getParameter("sort_fuel")	==null?"":request.getParameter("sort_fuel");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String gubun6 		= request.getParameter("gubun6")	==null?"":request.getParameter("gubun6");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");

	int sh_height 		= request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

	int cnt = 1; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&sort="+sort+"&sort_fuel="+sort_fuel+
					"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&gubun6="+gubun6+
					"&st_dt="+st_dt+"&end_dt="+end_dt+"&sh_height="+height+"&s_kd="+s_kd+"&t_wd="+t_wd+"";

%>
<!DOCTYPE html>
<html>
<head>
<title>FMS</title>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script type="text/javascript">
//리콜 안내문 발송 팝업
function recall_mail_pop(){
	var param="";
	var cnt=0;
	var fm = inner.document.form1;	
	var len=fm.elements.length;
	var chk500 = false;
	for(var i=0 ; i<len ; i++){
		var ck=fm.elements[i];		
		if(ck.name == "ch_cd"){		
			if(ck.checked == true){
				cnt++;
				if(cnt>500){	alert("일괄발송 건수는 최대 500건으로 제한됩니다.");	return;	}
				param += ck.value + ",";
			}
		}
	}
	fm.param.value 	= param;
	fm.cnt.value 	= cnt;
	
	fm.action = "/fms2/im_dmail/recall_send_pop.jsp";
	fm.target = "RECALL"
	
//	window.open("/fms2/im_dmail/recall_send_pop.jsp?param="+param+"&cnt="+cnt, "RECALL", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	window.open("", "RECALL", "left=10, top=10, width=900, height=750, scrollbars=yes, status=yes, resizable=yes");
	fm.submit();
}

//리스트크기에 맞게 체크버튼 선택창 세팅
function init_sel_checkbox(){
	var fm = inner.form1;
	var list_cnt = fm.list_size.value;
	var script="";
	var cnt = 0;
	var end_yn = false;
	for(var i=1;i<=list_cnt;i++){
		if(i%500==0){	
			var st_i = i - 499;
			script += "<option value='"+st_i+"~"+i+"'>"+st_i+" ~ "+i+"</option>\n";
			cnt++;
		}
		if(end_yn==false && 500 > (list_cnt-(cnt*500))){
			var st_i = Number(cnt*500)+Number(1);
			script += "<option value='"+st_i+"~"+list_cnt+"'>"+st_i+" ~ "+list_cnt+"</option>\n";
			end_yn = true;
		}
	}
	$("#sel_checkbox").html(script);
}

//체크하기
function check_checkbox(){
	var fm = inner.form1;	
	var sel_cb = $("#sel_checkbox option:selected").val().split("~");
	var list_size = fm.list_size.value;
	for(var i=1;i<=list_size;i++){
		if(i>=sel_cb[0] && i<=sel_cb[1]){
			$('#inner').get(0).contentWindow.$("#ch_"+i).prop("checked",true);			
		}else{
			$('#inner').get(0).contentWindow.$("#ch_"+i).prop("checked",false);
		}	
	}
}	
</script>

</head>
<body leftmargin="15" onload="javascript:init_sel_checkbox();">
<table border=0 cellspacing=0 cellpadding=0 width=1250 height=1%>	
    <tr> 
        <td align="left" style="font-size: 9pt;" width="80">
            <select id="sel_checkbox">
            </select>
            <a href="javascript:check_checkbox();">[체크하기]</a>
        </td>
        <td align="right" width="20%">
        	<input type="button" class="button" value="리콜 안내문 발송하기" onclick="javascript:recall_mail_pop();">
        </td>
    </tr>
</table>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='sort'		value='<%=sort%>'>
  <input type='hidden' name='sort_fuel'	value='<%=sort_fuel%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='gubun6' 	value='<%=gubun6%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='seq' 		value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
  		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
	  			<tr>
					<td>
		  				<iframe src="recall_send_sc_in.jsp<%=valus%>" name="inner" id="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
					</td>
	  			</tr>
			</table>
 		 </td>
	</tr>
</table>
</form>
</body>
</html>
