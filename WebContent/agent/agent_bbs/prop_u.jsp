<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*" %>
<%@ page import="acar.user_mng.*" %>
<jsp:useBean id="p_bean" class="acar.off_anc.PropBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");

	String idx = request.getParameter("idx")==null?"":request.getParameter("idx"); //제안순번

	
	OffPropDatabase p_db = OffPropDatabase.getInstance();
	
	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&asc="+asc+"&gubun1="+gubun1+"&gubun2="+gubun2+
					"&st_dt="+st_dt+"&end_dt="+end_dt;
			
	int prop_id = request.getParameter("prop_id")==null?0:Util.parseInt(request.getParameter("prop_id"));
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");

	
	int count1 = 0;
	int count2 = 0;
	int count3 = 0;
	
	p_bean = p_db.getPropBean(prop_id);
%>
<html>
<head><title>FMS</title>
<script language="JavaScript" src="/include/common.js"></script>
<script language='javascript'>
<!--
	
	var popObj = null;
	
//수정
function AncUp()
{
	var fm = document.form1;
	
	<%if(mode.equals("1")){%>
	
		if(fm.title.value == '')						{	alert('제목을 입력하십시오');			fm.title.focus(); 		return;	}
		else if(fm.content1.value == '')				{	alert('문제점을 입력하십시오');			fm.content1.focus(); 	return;	}
		else if(fm.content2.value == '')				{	alert('개선안을 입력하십시오');			fm.content2.focus(); 	return;	}
		else if(fm.content3.value == '')				{	alert('기대효과를 입력하십시오');		fm.content3.focus(); 	return;	}
		
		if(get_length(fm.title.value) > 300 ) 			{	alert("제목은 300자 까지만 입력할 수 있습니다.");				return;	}
		else if(get_length(fm.content1.value) > 4000)	{	alert("문제점은 4000자 까지만 입력할 수 있습니다.");			return;	}
		else if(get_length(fm.content2.value) > 4000)	{	alert("개선안은 4000자 까지만 입력할 수 있습니다.");			return;	}
		else if(get_length(fm.content3.value) > 4000)	{	alert("기대효과는 4000자 까지만 입력할 수 있습니다.");			return;	}
		
	<%}else if(mode.equals("2")){%>
	
		//if(fm.act_yn[1].checked == true && fm.act_dt.value == '')		{	alert('처리기한을 입력하십시오.');	fm.act_dt.focus(); 		return;	}
		if(fm.act_dt.value != ''){
			if(fm.prop_step[2].checked == false && fm.prop_step[3].checked == false  && fm.prop_step[4].checked == false && fm.prop_step[5].checked == false)	{	alert('상태를 확인하십시오.');					return;	}		
		}
		if(fm.prop_step[5].checked == true && fm.exp_dt.value == '')	{	alert('완료일자를 입력하십시오.');	fm.exp_dt.focus(); 		return;	}
		
	<%}%>
	
	if(!confirm('수정하시겠습니까?'))
		return;		
			
	fm.cmd.value = "u";
	fm.target="i_no";
	fm.action = "prop_null_ui.jsp";
	fm.submit();
}

//삭제
function AncDl()
{
	var fm = document.form1;
	
	if(!confirm('삭제하시겠습니까?'))
		return;	
		
	fm.cmd.value = "d";
	fm.target="i_no";
	fm.action = "prop_null_ui.jsp";	
	fm.submit();
}

//길이점검
function get_length(f) {
	var max_len = f.length;
	var len = 0;
	for(k=0;k<max_len;k++) {
		t = f.charAt(k);
		if (escape(t).length > 4)
			len += 2;
		else
			len++;
	}
	return len;
}

		//스캔등록
function scan_reg(idx){
		window.open("https://fms3.amazoncar.co.kr/fms2/off_anc/reg_scan.jsp?idx="+idx+"&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&prop_id=<%=prop_id%>", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
}

	//스캔삭제
function scan_del(idx){
		var theForm = document.form1;
		theForm.remove_idx.value =idx;
		
		if(!confirm('삭제하시겠습니까?')){		return;	}
		
		theForm.action = "./prop_del_scan_a.jsp";
		theForm.target = "i_no";
		theForm.submit();		

}
	
		//팝업윈도우 열기
function MM_openBrWindowOld(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/prop/"+theURL;
		window.open(theURL,winName,features);
}


function MM_openBrWindow(theURL,winName,features) { //v2.0
	
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
	     
		theURL = "https://fms3.amazoncar.co.kr/data/prop/"+theURL;
		
		popObj = window.open('',winName,features);
		popObj.location = theURL
		popObj.focus();

	}	
	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLp_db="javascript:self.focus()">
<form name="form1" method="post">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='asc'	 	value='<%=asc%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>      
  <input type="hidden" name="prop_id" 	value="<%=prop_id%>">
  <input type="hidden" name="mode" 		value="<%=mode%>">
  <input type="hidden" name="cmd" 		value="">
  <input type="hidden" name="remove_idx" 	value="">
  <input type="hidden" name="idx" 		value="<%=idx%>">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">  
  <input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">   
   <input type='hidden' name="public_yn" value="Y"> <!-- 외부업체는 무조건 공개 --> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>MASTER > 제안함 > <span class=style5> 
						<%=p_bean.getTitle()%> - 수정
						</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
		<td class=line2 ></td>
	</tr>
	<%if(mode.equals("1")){%>
	<tr>
	  <td class='line'>
		<table border="0" cellspacing="1" cellpadding="0" width=100%>			
		  <tr>
			<td width="12%" class="title">작성자</td>
			<td width="38%">&nbsp;<% if (  p_bean.getOpen_yn().equals("Y")) { %><%=p_bean.getUser_nm()%><% } else { %>비공개<% } %></td>
			<td width="12%" class="title">작성일</td>
			<td width="38%">&nbsp;<%=AddUtil.ChangeDate2(p_bean.getReg_dt())%></td>
		  </tr>
		 		 
		  <tr>
			<td class="title">제목</td>
			<td colspan="3">&nbsp;
			  <input type='text' name="title" id="title" value="<%=p_bean.getTitle()%>" size='112' class='text'></td>
		  </tr>									
		  <tr>
			<td class="title">문제점</td>
		    <td colspan="3">&nbsp;
			  <textarea name="content1" id="content1" cols='110' rows='10'><%=p_bean.getContent1()%></textarea></td>
		  </tr>
		  <tr>
			<td class="title">개선안</td>
		    <td colspan="3">&nbsp;
			  <textarea name="content2" id="content2" cols='110' rows='10'><%=p_bean.getContent2()%></textarea></td>
		  </tr>
		  <tr>
			<td class="title">기대효과</td>
			<td colspan="3">&nbsp;
			  <textarea name="content3" id="content3" cols='110' rows='10'><%=p_bean.getContent3()%></textarea> </td>
		  </tr>	
  
		</table>
	  </td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
	  <td colspan='4' align='right'> 
	    <%if(user_id.equals(p_bean.getReg_id())){%>
	    <a href="javascript:AncUp()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif"  aligh="absmiddle" border="0"></a>
		<%}%>
		<a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif"  aligh="absmiddle" border="0"></a>
	  </td>
	</tr>	
	<%}else if(mode.equals("2")){%>
	<tr>
	  <td class='line'>
		<table border="0" cellspacing="1" cellpadding="0" width=100%>			
		  <tr>
			<td width="12%" class="title">작성자</td>
			<td width="48%">&nbsp;<% if (  p_bean.getOpen_yn().equals("Y") ) { %><%=p_bean.getUser_nm()%><% } else { %>&nbsp;<% } %></td>
			<td width="12%" class="title">작성일</td>
			<td width="28%">&nbsp;<%=AddUtil.ChangeDate2(p_bean.getReg_dt())%></td>
		  </tr>
		  <tr>
			<td class="title">제목</td>
			<td colspan="3">&nbsp;<%=p_bean.getTitle()%></td>
		  </tr>									
		  <tr>
		  	<td class="title">채택여부</td>
			<td>
			  &nbsp;<input type='radio' name="use_yn" value='Y' <%if(p_bean.getUse_yn().equals("Y")){%>checked<%}%>>채택
			   <input type='radio' name="use_yn" value='M' <%if(p_bean.getUse_yn().equals("M")){%>checked<%}%>>수정채택
			   <input type='radio' name="use_yn" value='O' <%if(p_bean.getUse_yn().equals("O")){%>checked<%}%>>업무시정채택
			   <input type='radio' name="use_yn" value='I' <%if(p_bean.getUse_yn().equals("I")){%>checked<%}%>>정보제공
			  <input type='radio' name="use_yn" value='N' <%if(p_bean.getUse_yn().equals("N")){%>checked<%}%>>불채택		    
		    </td>    
		
			<td class="title">처리기한</td>
			<td>
			  &nbsp;<input type='text' name="act_dt" value='<%=AddUtil.ChangeDate2(p_bean.getAct_dt())%>' size='11' class='text' onBlur='javascript:this.value=ChangeDate(this.value);'>
			</td>
		  </tr>
		  <tr>
			<td class="title">상태</td>
			<td >
			  &nbsp;<input type='radio' name="prop_step" value='1' <%if(p_bean.getProp_step().equals("1")){%>checked<%}%>>의견수렴
		      <input type='radio' name="prop_step" value='2' <%if(p_bean.getProp_step().equals("2")){%>checked<%}%>>심사중
		      <input type='radio' name="prop_step" value='3' <%if(p_bean.getProp_step().equals("3")){%>checked<%}%>>재심중
		      <input type='radio' name="prop_step" value='5' <%if(p_bean.getProp_step().equals("5")){%>checked<%}%>>보류중
		      <input type='radio' name="prop_step" value='6' <%if(p_bean.getProp_step().equals("6")){%>checked<%}%>>처리중
   			  <input type='radio' name="prop_step" value='7' <%if(p_bean.getProp_step().equals("7")){%>checked<%}%>>완료
			</td>
			<td class="title">심사일자</td>
			<td>
			  &nbsp;<input type='text' name="eval_dt" value='<%=AddUtil.ChangeDate2(p_bean.getEval_dt())%>' size='11' class='text' onBlur='javascript:this.value=ChangeDate(this.value);'>
			</td>
		</tr>
		<tr>	
			<td class="title">완료일자</td>
			<td>
			  &nbsp;<input type='text' name="exp_dt" value='<%=AddUtil.ChangeDate2(p_bean.getExp_dt())%>' size='11' class='text' onBlur='javascript:this.value=ChangeDate(this.value);'>
			</td>			
			<td class="title">포상<br>(점수/금액)</td>
			<td>&nbsp;<input type='text' name="eval" size='4' class='num' value='<%=p_bean.getEval()%>' onBlur='javascript:this.value=parseDecimal(this.value);' >&nbsp;/
				&nbsp;<input type='text' name="prize" size='10' class='num' value='<%=p_bean.getPrize()%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
				&nbsp;<select name="eval_magam">
			    <option value="" <%if(p_bean.getEval_magam().equals("")){%>selected<%}%>>진행</option>
			    <option value="Y" <%if(p_bean.getEval_magam().equals("Y")){%>selected<%}%>>마감</option>
			
  			  </select>
				</td>				
		</tr>	
		<tr>	
			<td class="title">지급금액</td>
			<td>&nbsp;<input type='text' name="jigub_amt" size='10' class='num' value='<%=p_bean.getJigub_amt()%>' onBlur='javascript:this.value=parseDecimal(this.value);' ></td>						
			<td class="title">지급일자</td>
			<td>&nbsp;<input type='text' name="jigub_dt" value='<%=AddUtil.ChangeDate2(p_bean.getJigub_dt())%>' size='11' class='text' onBlur='javascript:this.value=ChangeDate(this.value);'></td>
		    </td>
		</tr>
		<tr>
			<td class="title">의견</td>
		         <td colspan="3">
			  &nbsp;<textarea name="content" cols='110' rows='10' style='IME-MODE: active'><%=p_bean.getContent()%></textarea></td>
		  </tr>
		  </tr>		  
		</table>
	  </td>	  
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	
	<tr>
	  <td colspan='4' align='right'> 
	 
	 
	    
	    <a href="javascript:window.close()" onMouseOver="window.status=''; return true"> <img src="/acar/images/center/button_close.gif"  aligh="absmiddle" border="0"> </a>
	  </td>
	</tr>	
	<%}%>
  </table>
</form>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script>
	// 특수문자 제한	2018.01.09		'와 "만 제한하기로 변경 2018.02.06
	var regex = /['"]/gi;
	var title;
	var content1;
	var content2;
	var content3;
	
	$("#title").bind("keyup",function(){title = $("#title").val();if(regex.test(title)){$("#title").val(title.replace(regex,""));}});	// 제목
	$("#content1").bind("keyup",function(){content1 = $("#content1").val();if(regex.test(content1)){$("#content1").val(content1.replace(regex,""));}});	// 문제점
	$("#content2").bind("keyup",function(){content2 = $("#content2").val();if(regex.test(content2)){$("#content2").val(content2.replace(regex,""));}});	// 개선안
	$("#content3").bind("keyup",function(){content3 = $("#content3").val();if(regex.test(content3)){$("#content3").val(content3.replace(regex,""));}});	// 기대효과
</script>
<iframe src="about:blank" name="i_no" width="100" height="100"  frameborder="0" noresize> </iframe>
</body>
</html>