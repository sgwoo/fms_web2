<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.insa_card.*, acar.common.*"%>
<%@ include file="/tax/cookies_base.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   

<%
	int rc_no=Integer.parseInt(request.getParameter("rc_no"));
	
	InsaRcDatabase icd = new InsaRcDatabase();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Insa_Rc_rcBean dto = icd.InsaRecselectOne(rc_no);
	
	//공급자
	Hashtable br = c_db.getBranch2(dto.getRc_branch().trim());
	
	//직무내용
	Insa_Rc_JobBean JbBean = icd.InsaRcJobselectOne2(dto.getRc_type());
	
	
	String content1 = JbBean.getRc_job_cont();
	if(!content1.contains("<div>")){ //신규 에디터로 작성한 내용이 아니면 \r\n 값을 <br/>태그로 치환함
		content1 = content1.replaceAll("\r\n","<br/>");
	}
	
	//지원자격
	Insa_Rc_QfBean QfBean = icd.InsaQfselectOne2(dto.getRc_edu());
	
	//복리후생비
	Insa_Rc_BnBean bnBean = icd.InsaBnselectOneSt(dto.getRc_type());
	
	String content2 = bnBean.getRc_bene_cont();
	if(!content2.contains("<div>")){ //신규 에디터로 작성한 내용이 아니면 \r\n 값을 <br/>태그로 치환함
		content2 = content2.replaceAll("\r\n","<br/>");
	}
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function modifyInfo(theURL,winName,features) { 
	window.open(theURL,winName,features);
}
//-->
</script>
<style type="text/css">
#topMenu { height:30px;  width: 1280px;  } 
#topMenu ul li {  list-style: none;  color: white;  background-color: #b0baec;  float: left; line-height: 30px; vertical-align: middle; text-align: center; margin-left:0} 
#topMenu .menuLink { text-decoration:none;  color: white;  display: block; width: 150px;  font-size: 12px; font-weight: bold;  font-family: "Trebuchet MS", Dotum, Arial;}
#topMenu .menuLink:hover {  color: red;  background-color: #4d4d4d;  }


</style>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' metdod='post' target=''>
<%@ include file="/include/search_hidden.jsp" %>
<input type="hidden" name="rc_no" value="<%=rc_no%>">
  <table border="0" cellspacing="0" cellpadding="0" width="800">
	<tr>
		<td align='right'>
			<button name="rc_no" value="rc_no" style="float:right;" onclick="javascript:modifyInfo('recruit_write.jsp?rc_no=<%=dto.getRc_no()%>', 'qfList', 'left=350, top=50, width=850, height=800, scrollbars=yes, status=yes');">수정</button>
		</td>
	</tr>       
  	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>모집요강</span></td>
	</tr>
	<tr><td class=line2></td></tr>
    <tr>
        <td class="line" width='100%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'> 
				<tr>
					<td scope="row" id="" class="title" width='20%'>모집직종</td> 
					<td>&nbsp;<%=dto.getRc_nm()%></td> 	
				</tr>
				<tr>
					<td scope="row" id="" class="title">채용인원</td> 
					<td>&nbsp;<%=dto.getRc_hire_per()%> 명</td> 
				</tr>				
			</table>
		</td>
    </tr>
	<tr> 
        <td class=h></td>
    </tr>  	  
	<tr><td class=line2></td></tr>    
    <tr>
        <td class="line" width='100%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'> 
				<tr>
				    <td scope="row" id="" class="title" width='20%'>직무내용</td> 
					<td align="center" valign="top">
		          		<table border="0" cellspacing="0" cellpadding="10" width=100%>
		              		<tr>
		                		<td style="padding:10px;"><%=content1%></td>
		              		</tr>
		          		</table>
		          	</td>
				</tr>				
			</table>
		</td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>  	  
	<tr><td class=line2></td></tr>    
    <tr>
        <td class="line" width='100%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'> 
				<tr>
				    <td scope="row" id="" class="title" width='20%'>복리후생비</td> 
					<td align="center" valign="top">
		          		<table border="0" cellspacing="0" cellpadding="10" width=100%>
		              		<tr>
		                		<td style="padding:10px;"><%=content2%></td>
		              		</tr>
		          		</table>
		          	</td>
				</tr>				
			</table>
		</td>
    </tr>
	<tr> 
        <td class=h></td>
    </tr>  	      
  	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>지원자격/근무조건</span></td>
	</tr>
	<tr><td class=line2></td></tr>
    <tr>
        <td class="line" width='100%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'> 
	        	<tr>
	        		<td class='title' width='20%'>학력조건</th>
	        		<td width='80%'>&nbsp;<b><%=dto.getEdu_nm() %></b></td>
	        	</tr>
	        	<tr>
	        		<td class='title' width='20%'>고용형태</th>
	        		<td width='80%'>&nbsp;<%=QfBean.getRc_qf_var1()%></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>경력조건</th>
	        		<td width='80%'>&nbsp;<%=QfBean.getRc_qf_var2()%></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>임금</th>
	        		<td width='80%'>&nbsp;<%=QfBean.getRc_qf_var3()%></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>초임연봉</th>
	        		<td width='80%'>&nbsp;<%=QfBean.getRc_qf_var4()%></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>근무형태</th>
	        		<td width='80%'>&nbsp;<%=QfBean.getRc_qf_var5()%></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>근로시간</th>
	        		<td width='80%'>&nbsp;<%=QfBean.getRc_qf_var6()%></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>근무시간</th>
	        		<td width='80%'>&nbsp;<%=QfBean.getRc_qf_var7()%></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>사회보험</th>
	        		<td width='80%'>&nbsp;<%=QfBean.getRc_qf_var8()%></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>퇴직급여</th>
	        		<td width='80%'>&nbsp;<%=QfBean.getRc_qf_var9()%></td>
	        	</tr> 
			</table>
		</td>
    </tr>
	<tr> 
        <td class=h></td>
    </tr>  	      
  	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>근무예정지</span></td>
	</tr>
	<tr><td class=line2></td></tr>
    <tr>
        <td class="line" width='100%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'> 
				<tr>
					<td scope="row" id="" class="title" width='20%'>지점</td> 
					<td>&nbsp;<%=dto.getRc_branch()%></td> 	
				</tr>	
				<%if(!dto.getRc_branch().equals("수도권")){ %>		
				<tr>
					<td scope="row" id="" class="title">주소</td> 
					<td>&nbsp;<%=br.get("BR_ADDR")%></td> 
				</tr>
				<tr>
					<td scope="row" id="" class="title">연락처</td> 
					<td>&nbsp;<%=br.get("TEL")%></td> 
				</tr>
				<%} %>
			</table>
		</td>
    </tr>    
	<tr> 
        <td class=h></td>
    </tr>  	      
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>전형방법</span></td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" width='100%' >
			<table border="0" cellspacing="1" cellpadding="0" width='100%'> 
				<tr>
					<td class="title" width='20%'>접수마감일</td> 
					<td >&nbsp;<%=AddUtil.ChangeDate2(dto.getRc_apl_ed_dt())%></td> 
				</tr>
				<tr>
					<td class="title" width='20%'>합격자발표</td> 
					<td >&nbsp;<%=AddUtil.ChangeDate2(dto.getRc_pass_dt())%></td> 
				</tr>
				<tr>
					<td class="title" width='20%'>전형방법</td> 
					<td >&nbsp;<%=dto.getRc_apl_mat()%></td> 
				</tr>
				<tr>
					<td class="title" width='20%'>접수방법</td> 
					<td >&nbsp;E-Mail (현장 및 우편접수 안됨)</td> 
				</tr>
				<tr>
					<td class="title" width='20%'>접수처</td> 
					<td >&nbsp;recruit@amazoncar.co.kr</td> 
				</tr>
				<tr>
					<td class="title" width='20%'>제출서류</td> 
					<td >&nbsp;이력서, 자기소개서, 졸업증명서, 기타(본인에게 유리한 모든 서류)</td> 
				</tr>
			</table>
	    </td>
    </tr>
	<tr> 
        <td class=h></td>
    </tr>  	      
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>채용담당자</span></td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" width='100%' >
			<table border="0" cellspacing="1" cellpadding="0" width='100%'> 
				<tr>
					<td class="title" width='20%'>담당자</td> 
					<td  name="rc_apl_ed_dt">&nbsp;<%=dto.getRc_manager()%></td> 
				</tr>
				<tr>
					<td class="title" width='20%'>연락처</td> 
					<td  name="rc_apl_ed_dt">&nbsp;<%=dto.getRc_tel()%></td> 
				</tr>				
			</table>
	    </td>
    </tr>    
    <tr> 
        <td class=h></td>
    </tr> 
	</table>
</form>
</body>
</html>
