<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.partner.*"%>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");  //1:고소고발, 2:소송, 3:고소고발 진행상황 내용등록
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	
	
	Serv_EmpDatabase se_dt = Serv_EmpDatabase.getInstance();
	
		
	Hashtable ht = se_dt.getsd_vidw_modify(off_id, serv_id);				
%>

<html>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script language='javascript' src='/include/common.js'></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery.min.js"></script>
<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
 
<script>
$(function() {
  $( "#sd_dt" ).datepicker({
	  
    dateFormat: 'yy-mm-dd',
    prevText: '이전 달',
    nextText: '다음 달',
    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
    monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
    dayNames: ['일','월','화','수','목','금','토'],
    dayNamesShort: ['일','월','화','수','목','금','토'],
    dayNamesMin: ['일','월','화','수','목','금','토'],
    showMonthAfterYear: true,
    yearSuffix: '년'
  });
});
</script>
<script language='javascript'>
<!--	
		
	//등록
	function sd_save(){
		var fm = document.form1;
		
		<%if(serv_id.equals("")){%>
		if(!confirm('등록하시겠습니까?')){	return;	}	
		fm.cmd.value = 'i';
		<%}else{%>
		if(!confirm('추가하시겠습니까?')){	return;	}	
		fm.cmd.value = 'i2';
		<%}%>
		fm.action = "sd_view_reg_a.jsp";
		fm.target = "i_no";
		fm.submit()
		
	}
	
	function sd_update(){
		var fm = document.form1;
		
		if(!confirm('수정 하시겠습니까?')){	return;	}	
		fm.cmd.value = 'sd_modify';
		fm.action = "sd_view_reg_a.jsp";
		fm.target = "i_no";
		fm.submit()
		
	}

//-->
</script>
</head>

<body>
<form name='form1' method='post' >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=ck_acar_id%>'>
<input type='hidden' name='off_id' value='<%=off_id%>'>
<input type='hidden' name='serv_id' value='<%=serv_id%>'>
<input type='hidden' name='cmd' value=''>
<%if(serv_id.equals("")){%>  
<div class="navigation">
	<span class=style1></span><span class=style5>상담현황 신규등록</span>
</div>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
			<tr> 
				<td class='title' width=15%>구분</td>
				<td colspan="3">&nbsp;
					<select name="gubun">
						<option value="1">방문</option>
						<option value="2">전화(수신)</option>
						<option value="3">전화(발신)</option>
						<option value="4">메일(수신)</option>
						<option value="5">메일(발신)</option>
						<option value="6">종결</option>
					</select>
				</td>
			</tr>
			<tr> 
				<td class='title' width=15%>상담일자</td>
				<td colspan="3">&nbsp;&nbsp;<input type="text" name="sd_dt" id="sd_dt" size="12" value="<%=AddUtil.getDate()%>" class="date-picker" title="YYYY-MM-DD" READONLY>※날짜를 선택하면 달력이 표시되어 원하는 날짜를 선택할 수 있습니다.</td>
			</tr>
			<tr> 
				<td class='title' width=15%>거래처 상담자</td>
				<td colspan="3">&nbsp;&nbsp;<input type="text" name="g_smng1" size="20"  class="text" value="">&nbsp;&nbsp; / 
				&nbsp;&nbsp;<input type="text" name="g_smng2" size="20"  class="text" value="">&nbsp;&nbsp; / 
				&nbsp;&nbsp;<input type="text" name="g_smng3" size="20"  class="text" value=""></td>
			</tr>
			<tr>	
				<td class='title' width=15%>당사 상담자</td>
				<td colspan="3">&nbsp;
					<select name="d_smng1">
						<option value="-">당사 상담자 선택</option>
						<option value="대표이사">대표이사</option>
						<option value="총무팀장">총무팀장</option>
						<option value="김태우과장">김태우과장</option>
						<option value="권명숙대리">권명숙대리</option>
					</select>&nbsp;&nbsp; / 
				&nbsp;&nbsp;<select name="d_smng2">
						<option value="-">당사 상담자 선택</option>
						<option value="대표이사">대표이사</option>
						<option value="총무팀장">총무팀장</option>
						<option value="김태우과장">김태우과장</option>
						<option value="권명숙대리">권명숙대리</option>
					</select>&nbsp;&nbsp; / 
				&nbsp;&nbsp;<select name="d_smng3">
						<option value="-">당사 상담자 선택</option>
						<option value="대표이사">대표이사</option>
						<option value="총무팀장">총무팀장</option>
						<option value="김태우과장">김태우과장</option>
						<option value="권명숙대리">권명숙대리</option>
					</select>
			</tr>
			<tr> 
				<td class='title' width=15%>금리</td>
				<td>&nbsp;&nbsp;<input type="text" name="item1" size="20"  class="text" value=""></td>
				<td class='title' width=15%>한도</td>
				<td>&nbsp;&nbsp;<input type="text" name="item2" size="20"  class="text" value=""></td>
			</tr>
			<tr> 
				<td class='title' width=15%>진행상황</td>
				<td colspan="3">&nbsp;&nbsp;<textarea name="note" cols=80 rows=4>&nbsp;</textarea>
			</tr>
          
        </table>
      </td>
    </tr>
	<tr>
        <td><input type="button" class="button" value="신규등록" onclick="sd_save()"/></td>
    </tr>
</table>	
<%}else if(!serv_id.equals("")){%>  	
<div class="navigation">
	<span class=style1></span><span class=style5>상담현황 수정등록</span>
</div>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
      <td class="line"> 
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
			<tr> 
				<td class='title' width=15%>구분</td>
				<td colspan="3">&nbsp;
					<select name="gubun">
						<option value="1" <%if(ht.get("GUBUN").equals("1"))%>selected<%%>>방문</option>
						<option value="2" <%if(ht.get("GUBUN").equals("2"))%>selected<%%>>전화(수신)</option>
						<option value="3" <%if(ht.get("GUBUN").equals("3"))%>selected<%%>>전화(발신)</option>
						<option value="4" <%if(ht.get("GUBUN").equals("4"))%>selected<%%>>메일(수신)</option>
						<option value="5" <%if(ht.get("GUBUN").equals("5"))%>selected<%%>>메일(발신)</option>
						<option value="6" <%if(ht.get("GUBUN").equals("6"))%>selected<%%>>종결</option>
					</select>
				</td>
			</tr>
			<tr> 
				<td class='title' width=15%>상담일자</td>
				<td colspan="3">&nbsp;&nbsp;<input type="text" name="sd_dt" id="sd_dt" size="12" value="<%=AddUtil.ChangeDate2(String.valueOf(ht.get("SD_DT")))%>" class="date-picker" title="YYYY-MM-DD" READONLY>※날짜를 선택하면 달력이 표시되어 원하는 날짜를 선택할 수 있습니다.</td>
			</tr>
			<tr> 
				<td class='title' width=15%>거래처 상담자</td>
				<td colspan="3">&nbsp;&nbsp;<input type="text" name="g_smng1" size="20"  class="text" value="<%if(!ht.get("G_SMNG1").equals("")){%><%=ht.get("G_SMNG1")%><%}%>">&nbsp;&nbsp; / 
				&nbsp;&nbsp;<input type="text" name="g_smng2" size="20"  class="text" value="<%if(!ht.get("G_SMNG2").equals("")){%><%=ht.get("G_SMNG2")%><%}%>">&nbsp;&nbsp; / 
				&nbsp;&nbsp;<input type="text" name="g_smng3" size="20"  class="text" value="<%if(!ht.get("G_SMNG3").equals("")){%><%=ht.get("G_SMNG3")%><%}%>"></td>
			</tr>
			<tr>	
				<td class='title' width=15%>당사 상담자</td>
				<td colspan="3">&nbsp;
					<select name="d_smng1">
						<option value="-" <%if(ht.get("D_SMNG1").equals("-"))%>selected<%%>>당사 상담자 선택</option>
						<option value="대표이사" <%if(ht.get("D_SMNG1").equals("대표이사"))%>selected<%%>>대표이사</option>
						<option value="총무팀장" <%if(ht.get("D_SMNG1").equals("총무팀장"))%>selected<%%>>총무팀장</option>
						<option value="김태우과장" <%if(ht.get("D_SMNG1").equals("김태우과장"))%>selected<%%>>김태우과장</option>
						<option value="권명숙대리" <%if(ht.get("D_SMNG1").equals("권명숙대리"))%>selected<%%>>권명숙대리</option>
					</select>&nbsp;&nbsp; / 
				&nbsp;&nbsp;<select name="d_smng2">
						<option value="-" <%if(ht.get("D_SMNG2").equals("-"))%>selected<%%>>당사 상담자 선택</option>
						<option value="대표이사" <%if(ht.get("D_SMNG2").equals("대표이사"))%>selected<%%>>대표이사</option>
						<option value="총무팀장" <%if(ht.get("D_SMNG2").equals("총무팀장"))%>selected<%%>>총무팀장</option>
						<option value="김태우과장" <%if(ht.get("D_SMNG2").equals("김태우과장"))%>selected<%%>>김태우과장</option>
						<option value="권명숙대리" <%if(ht.get("D_SMNG2").equals("권명숙대리"))%>selected<%%>>권명숙대리</option>
					</select>&nbsp;&nbsp; / 
				&nbsp;&nbsp;<select name="d_smng3">
						<option value="-" <%if(ht.get("D_SMNG3").equals("-"))%>selected<%%>>당사 상담자 선택</option>
						<option value="대표이사" <%if(ht.get("D_SMNG3").equals("대표이사"))%>selected<%%>>대표이사</option>
						<option value="총무팀장" <%if(ht.get("D_SMNG3").equals("총무팀장"))%>selected<%%>>총무팀장</option>
						<option value="김태우과장" <%if(ht.get("D_SMNG3").equals("김태우과장"))%>selected<%%>>김태우과장</option>
						<option value="권명숙대리" <%if(ht.get("D_SMNG3").equals("권명숙대리"))%>selected<%%>>권명숙대리</option>
					</select>
			</tr>
			<tr> 
				<td class='title' width=15%>금리</td>
				<td>&nbsp;&nbsp;<input type="text" name="item1" size="20"  class="text" value="<%=ht.get("ITEM1")%>"></td>
				<td class='title' width=15%>한도</td>
				<td>&nbsp;&nbsp;<input type="text" name="item2" size="20"  class="text" value="<%=ht.get("ITEM2")%>"></td>
			</tr>
			<tr> 
				<td class='title' width=15%>진행상황</td>
				<td colspan="3">&nbsp;&nbsp;<textarea name="note" cols=80 rows=4>&nbsp;<%=ht.get("NOTE")%></textarea>
			</tr>
          
        </table>
      </td>
    </tr>
	<tr>
      <td align="right">
		<input type="button" class="button" value="수정" onclick="sd_update()"/>
		<input type="button" class="button" value="닫기" onclick="window.close()"/>
	  </td>
    </tr>
<%}%>	
    <tr>
        <td></td>
    </tr>
    
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
