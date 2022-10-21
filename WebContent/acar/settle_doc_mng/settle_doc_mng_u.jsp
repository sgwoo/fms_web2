<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	
	
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	//미수채권 리스트
	Vector FineList = FineDocDb.getSettleDocLists(doc_id);
%>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//수정하기
	function fine_update(){
		var fm = document.form1;
		fm.target = "i_no";
		fm.action = "settle_doc_mng_u_a.jsp";
		fm.submit();
	}	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}			
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post' enctype="multipart/form-data">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='s_end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='doc_id' value='<%=doc_id%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=820>
    <tr> 
      <td><font color="navy">채권관리 -> </font><font color="red">최고장관리</font></td>
      <td align="right">
	  <a href="javascript:fine_update();" onMouseOver="window.status=''; return true"><img src="/images/update.gif" width="50" height="18" aligh="absmiddle" border="0"></a>&nbsp;&nbsp;
	  <a href="javascript:window.close();" onMouseOver="window.status=''; return true"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
      <td align="right" width="20">&nbsp;</td>
    </tr>
    <tr> 
      <td class="line" colspan="2" width="800"> 
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td class='title' width="80">문서번호</td>
            <td><%=FineDocBn.getDoc_id()%></td>
          </tr>
          <tr> 
            <td class='title' width="80">시행일자</td>
            <td><input type="text" name="doc_dt" size="11" class="text" value="<%=AddUtil.ChangeDate2(FineDocBn.getDoc_dt())%>" onBlur='javscript:this.value = ChangeDate(this.value);'></td>
          </tr>
          <tr> 
            <td width="80" rowspan="2" class='title'>수신</td>
            <td><%=FineDocBn.getGov_nm()%></td>
          </tr>
          <tr>
            <td><input type="text" name="gov_addr" size="100" class="text" value="<%=FineDocBn.getGov_addr()%>"></td>
          </tr>
          <tr> 
            <td class='title' width="80">참조</td>
            <td><input type="text" name="mng_dept" size="50" class="text" value="<%=FineDocBn.getMng_dept()%>">
			</td>
          </tr>
          <tr> 
            <td class='title' width="80">제목</td>
            <td><input type="text" name="title" size="100" class="text" value="<%=FineDocBn.getTitle()%>">
			<!--
			  <select name='title'>
                  <option value='' <%if(FineDocBn.getTitle().equals(""))%>selected<%%>>선택</option>
                  <option value="최고장"               				<%if(FineDocBn.getTitle().equals("최고장"))%>selected<%%>							>최고장</option>				  
                  <option value="납입최고 및 해지예고" 				<%if(FineDocBn.getTitle().equals("납입최고 및 해지예고"))%>selected<%%>				>납입최고 및 해지예고</option>				  
				  <option value="해지예고통보" 						<%if(FineDocBn.getTitle().equals("해지예고통보"))%>selected<%%>						>해지예고통보</option>				  
				  <option value="해지통보" 							<%if(FineDocBn.getTitle().equals("해지통보"))%>selected<%%>							>해지통보</option>				  
                  <option value="해지통보 및 중도위약금 납입고지" 	<%if(FineDocBn.getTitle().equals("해지통보 및 중도위약금 납입고지"))%>selected<%%>	>해지통보 및 중도위약금 납입고지</option>
                  <option value="계약해지 및 차량반납 통보" 		<%if(FineDocBn.getTitle().equals("계약해지 및 차량반납 통보"))%>selected<%%>		>계약해지 및 차량반납 통보</option>
                  <option value="기타" 								<%if(FineDocBn.getTitle().equals("기타"))%>selected<%%>								>기타</option>				  				  
               </select>
			   --></td>
          </tr>          
          <tr> 
            <td class='title' width="80">유예기간</td>
            <td><input type="text" name="end_dt" size="11" class="text" value="<%=AddUtil.ChangeDate2(FineDocBn.getEnd_dt())%>" onBlur='javscript:this.value = ChangeDate(this.value);'></td>
          </tr>		
          <tr> 
            <td class='title' width="80">스캔</td>
            <td><a href="https://fms3.amazoncar.co.kr/data/stop_doc/<%=FineDocBn.getFilename()%>" target="_blank"><%=FineDocBn.getFilename()%></a>
			<br><input type="file" name="filename2" size="40"></td>
          </tr>		  		  
		    		  
        </table>
      </td>
      <td width="20">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="3">&nbsp;</td>
    </tr>
    <tr> 
      <td align='right' colspan="3">&nbsp;</td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
