<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*,  acar.user_mng.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<html>
<head><title></title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//기안넘기기
	function doc_card_change(){
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
		 	alert("1건이상 선택하세요.");
			return;
		}	
		
		//fm.target = "i_no";
		fm.target = "_blank";
		fm.action = "card_change_many.jsp";
		fm.submit();	
	}			
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	int cnt = 3; //현황 출력 영업소 총수
	 
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*25)-245;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<form name='form1'  method='post' target='t_content'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='cardno' value=''>
<input type='hidden' name='buy_id' value=''>
<input type='hidden' name='idx' value='<%=idx%>'>
	<input type="hidden" name="cgs_ok" value="<%=cgs_ok%>">
		
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
  <tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>총 <input type='text' name='size' value='' size='4' class=whitenum> 건</span>
	
	  </td>
	</tr>  
    <tr> 
      <td height="<%=height%>"><iframe src="doc_mng_sc3_in.jsp<%=hidden_value%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
        </iframe> </td><!--모니터높이 - sh 길이 - 상단메뉴 길이 - (라인수*40)-->
    </tr>  
</table>
</form>
</body>
</html>
