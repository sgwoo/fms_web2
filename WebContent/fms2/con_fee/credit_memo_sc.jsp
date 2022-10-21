<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String r_st 	= request.getParameter("r_st")==null?"1":request.getParameter("r_st");
	String fee_tm 	= request.getParameter("fee_tm")==null?"A":request.getParameter("fee_tm");
	String tm_st1 	= request.getParameter("tm_st1")==null?"0":request.getParameter("tm_st1");
	String bus_id2 	= request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	String mode 	= request.getParameter("mode")==null?"dly_mm":request.getParameter("mode");
	String memo_st 	= request.getParameter("memo_st")==null?"client":request.getParameter("memo_st");
	String mm_st2 	= request.getParameter("mm_st2")==null?"settle":request.getParameter("mm_st2");
	
	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save()
	{
		if(confirm('등록하시겠습니까?'))
		{
			var fm = document.form1;
			if((fm.t_reg_dt.value == '') || !isDate(fm.t_reg_dt.value))			{	alert('등록일을 확인하십시오');		return;	}
			if(fm.t_speaker.value == '')							{	alert('담당자를 확인하십시오');		return;	}
			if(fm.t_promise_dt.value != '' && !isDate(fm.t_promise_dt.value))		{	alert('납부약속일을 확인하십시오');	return;	}
			if(fm.t_content.value == '')							{	alert('메모내용을 확인하십시오');	return;	}
			
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
		
			fm.target='i_no';
			fm.action='fee_memo_i_a.jsp';
			fm.submit();
			
			link.getAttribute('href',originFunc);
		}
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='r_st' value='<%=r_st%>'>
<input type='hidden' name='fee_tm' value='<%=fee_tm%>'>
<input type='hidden' name='tm_st1' value='<%=tm_st1%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='memo_st' value='<%=memo_st%>'>
<input type='hidden' name='mm_st2' value='<%=mm_st2%>'>
<input type='hidden' name='from_page' value='credit_memo'>
<input type='hidden' name='client_id' value='<%=base.getClient_id()%>'>
<table border="0" cellspacing="0" cellpadding="0" width=850>	
    <tr>
	    <td colspan='2'>
		  <%if(mode.equals("credit_doc")){%><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(memo_st.equals("client")){%>거래처 통합&nbsp;<%}%>최고장발행</span>&nbsp;<a href="http://service.epost.go.kr/iservice/trace/Trace.jsp" target='_blank'><img src=/acar/images/center/button_dgbd.gif align=absmiddle border=0></a><%}%>
		  <%if(mode.equals("cms_mm")){%><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(memo_st.equals("client")){%>거래처 통합&nbsp;<%}%>CMS 메모</span><%if(memo_st.equals("client")){%>(최근한달이내)<%}%><%}%>
		  <%if(mode.equals("dly_mm")){%><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(memo_st.equals("client")){%>거래처 통합&nbsp;<%}%>통화 메모</span><%}%>
		  </td>
	</tr>
	<%if(mode.equals("credit_doc")){%>
    <tr>
	    <td class=line2></td>
	</tr>
    <tr>
	    <td class='line'  width='834'>			 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>					
                    <td width='17%' class='title'>문서번호</td>
        		    <td width='15%' class='title'>시행일자</td>
        		    <td width='40%' class='title'>제목</td>					
                    <td width='14%' class='title'>유예기간</td>
                    <td width='10%' class='title'>스캔</td>	
                    <td width='4%' class='title'>결과</td>		  
		        </tr>
	        </table>
	    </td>
	    <td width='17'>&nbsp;</td>
    </tr>			
	<tr>
		<td colspan='2'>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
					  <iframe src="credit_memo_sc_in_credit_doc.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&r_st=<%=r_st%>&fee_tm=<%=fee_tm%>&tm_st1=<%=tm_st1%>&mode=<%=mode%>&memo_st=<%=memo_st%>&client_id=<%=base.getClient_id()%>" name="i_no" width="100%" height="490" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan='2' align='right'> 
		  <a href="javascript:parent.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>
	</tr>			
	<%}else if(mode.equals("cms_mm")){%>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr>
	    <td class='line'  width='834'>			 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>					
                    <td width='12%' class='title'>계약번호</td>				
                    <td width='8%' class='title'>작성자</td>
        		    <td width='9%' class='title'>작성일</td>
        		    <td width='11%' class='title'>담당자</td>					
                    <td width='60%' class='title'>메모</td>					
		        </tr>
	        </table>
	    </td>
	    <td width='17'>&nbsp;</td>
    </tr>	
	<tr>
		<td colspan='2'>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
					  <iframe src="credit_memo_sc_in_cms_mm.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&r_st=<%=r_st%>&fee_tm=<%=fee_tm%>&tm_st1=<%=tm_st1%>&mode=<%=mode%>&memo_st=<%=memo_st%>&client_id=<%=base.getClient_id()%>" name="i_no" width="100%" height="490" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan='2' align='right'> 
		  <a href="javascript:parent.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>
	</tr>		
	<%}else if(mode.equals("dly_mm")){%>
    <tr>
	    <td class=line2></td>
	</tr>
    <tr>
	    <td class='line'  width='834'>			 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>					
                    <td width='8%' class='title'>구분</td>
                    <td width='12%' class='title'>계약번호</td>
                    <td width='8%' class='title'>작성자</td>
        		        <td width='9%' class='title'>작성일</td>
        		        <td width='11%' class='title'>담당자</td>
                    <td width='42%' class='title'>메모</td>
                    <td width='10%' class='title'>납부약속일</td>
		        </tr>
	        </table>
	    </td>
	    <td width='17'>&nbsp;</td>
    </tr>	
	<tr>
		<td colspan='2'>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
					  <iframe src="credit_memo_sc_in_dly_mm.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&r_st=<%=r_st%>&fee_tm=<%=fee_tm%>&tm_st1=<%=tm_st1%>&mode=<%=mode%>&memo_st=<%=memo_st%>&client_id=<%=base.getClient_id()%>" name="i_no" width="100%" height="415" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
    <tr>
        <td colspan='2' class=line2></td>
    </tr>	
	<tr>
		<td colspan='2' class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width="10%"> 구분 </td>
                    <td width=10%>&nbsp; 
                    	<select name="t_mm_st">
            				    <option value="settle" <%if(mm_st2.equals("settle")){%>selected<%}%>>채권관리</option>
            				    <option value="dist" <%if(mm_st2.equals("dist")){%>selected<%}%>>초과운행</option>
            				    <option value="etc" <%if(mm_st2.equals("etc")){%>selected<%}%>>기타</option>
            			    </select>
                    </td>
                    <td class='title' width="10%"> 작성일 </td>
                    <td width=15%>&nbsp; <input type='text' name='t_reg_dt' size='11' class='text' onBlur='javascript:this.value = ChangeDate(this.value);' value = '<%=Util.getDate()%>'></td>
                    <td class='title' width="10%"> 담당자</td>
                    <td width="15%">&nbsp; <input type='text' name='t_speaker' size='20' class='text' style='IME-MODE: active'></td>
                    <td class='title' width="15%"> 납부약속일</td>
                    <td width="15%">&nbsp; <input type='text' name='t_promise_dt' size='11' class='text' onBlur='javascript:this.value = ChangeDate(this.value);'></td>
                </tr>
                <tr> 
                    <td class='title'> 내용</td>
                    <td colspan='7'>&nbsp; <textarea name='t_content' rows='4' cols='106'></textarea> 
                    </td>
                </tr>
            </table>
		</td>
	</tr>
	
	<tr>
		<td colspan='2' align='right'> 
		  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
		  <a id="submitLink" href="javascript:save()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;
		  <%}%>
		  <a href="javascript:parent.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>
	</tr>	
	
        <%}%>		
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize></iframe>
</body>
</html>
