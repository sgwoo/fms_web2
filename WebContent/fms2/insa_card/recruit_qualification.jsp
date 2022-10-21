<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.insa_card.*"%>
<%@ include file="/tax/cookies_base.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   

<%
	int rc_no=Integer.parseInt(request.getParameter("rc_no"));
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String reg_edu = request.getParameter("reg_edu")==null?"":request.getParameter("reg_edu");

	InsaRcDatabase icd = new InsaRcDatabase();
	Insa_Rc_QfBean QfBean = icd.InsaQfselectOne(rc_no);
	
	// 코드 리스트
	Vector vt_job = icd.getList("2");
	int vt_size = vt_job.size();
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function infoCan(){ 
		opener.window.location='recruit_qualification_sc.jsp';
		close();
	}
	
	function deleteQf(){ 
		var theForm = document.form;
		if(!confirm('삭제하시겠습니까?')){		return;	}
	
		theForm.action = "recruit_qualification_up.jsp.jsp?gubun=d";
		theForm.submit();
	}
	
	function updateQf(){ 
		var theForm = document.form;
		
		if ( theForm.rc_edu.value =="") { alert("학력조건을 선택하십시오."); return; }	
		
		if(!confirm('저장하시겠습니까?')){		return;	}
				
		theForm.action = "recruit_qualification_up.jsp.jsp";
		theForm.submit();
	}
	
//-->	
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form'class="form"  method='post' target='qfList'>
<%@ include file="/include/search_hidden.jsp" %>
  <table border="0" cellspacing="0" cellpadding="0" width="800">
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>지원자격/근무조건</span></td>
	</tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr><td class=line2></td></tr>
    <tr>
        <td class="line" width='100%'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>   
				
	        	<tr>
	        		<td class='title' width='20%'>학력조건</th>
	        		<td width='80%'>&nbsp;
	        		  <select name='rc_edu'>	
	        		  <% //신규등록이면 
	        		  if ( rc_no == 0 ) { %>
	        		    <option value="">--선택--</option>
	        		  <%	if(vt_size > 0){
								for(int i = 0 ; i < vt_size ; i++){
									Hashtable ht = (Hashtable)vt_job.elementAt(i); %>
		                <option value='<%=ht.get("RC_CODE")%>'> <%= ht.get("RC_NM")%></option>
		                <%		}
							}%>
	        		 <% } else { %> 
	        		  
		                <%	if(vt_size > 0){
								for(int i = 0 ; i < vt_size ; i++){
									Hashtable ht = (Hashtable)vt_job.elementAt(i); %>
		                <option value='<%=ht.get("RC_CODE")%>' <%if(QfBean.getRc_edu().equals((String)ht.get("RC_CODE"))){%>selected<%}%>><%= ht.get("RC_NM")%></option>
		                <%		}
							}%>
					<% } %>		
		              </select>
			        </td>	        	
	              		
	        	</tr>
	        	<tr>
	        		<td class='title' width='20%'>고용형태</th>
	        		<td width='80%'>&nbsp;
	        		  <select name="rc_qf_var1" >
	        		<% //신규등록이면 
	        		  if ( rc_no == 0 ) { %>
	        		  	  <option value="정규직" selected>정규직</option>
                 		  <option value="비정규직">비정규직</option>                 
	        		 <% } else { %> 
	        		    <option value="정규직" <% if(QfBean.getRc_qf_var1().equals("정규직")){%>selected<%}%>>정규직</option>
               			<option value="비정규직" <% if(QfBean.getRc_qf_var1().equals("비정규직")){%>selected<%}%>>비정규직</option>
					<% } %>	
             		 </select>
              		</td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>경력조건</th>
	        		<td width='80%'>&nbsp;<input type="text" name="rc_qf_var2" size='40' value="<%=QfBean.getRc_qf_var2()==null?"":QfBean.getRc_qf_var2() %>"/></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>임금</th>
	        		<td width='80%'>&nbsp;<input type="text" name="rc_qf_var3" size='40' value="<%=QfBean.getRc_qf_var3()==null?"":QfBean.getRc_qf_var3() %>"/></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>초임연봉</th>
	        		<td width='80%'>&nbsp;<input type="text" name="rc_qf_var4" size='40' value="<%=QfBean.getRc_qf_var4()==null?"":QfBean.getRc_qf_var4() %>"/></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>근무형태</th>
	        		<td width='80%'>&nbsp;<input type="text" name="rc_qf_var5" size='40' value="<%=QfBean.getRc_qf_var5()==null?"":QfBean.getRc_qf_var5() %>"/></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>근로시간</th>
	        		<td width='80%'>&nbsp;<input type="text" name="rc_qf_var6" size='40' value="<%=QfBean.getRc_qf_var6()==null?"":QfBean.getRc_qf_var6() %>"/></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>근무시간</th>
	        		<td width='80%'>&nbsp;<input type="text" name="rc_qf_var7" size='40' value="<%=QfBean.getRc_qf_var7()==null?"":QfBean.getRc_qf_var7() %>"/></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>사회보험</th>
	        		<td width='80%'>&nbsp;<input type="text" name="rc_qf_var8" size='40' value="<%=QfBean.getRc_qf_var8()==null?"":QfBean.getRc_qf_var8() %>"/></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>퇴직급여</th>
	        		<td width='80%'>&nbsp;<input type="text" name="rc_qf_var9" size='40' value="<%=QfBean.getRc_qf_var9()==null?"":QfBean.getRc_qf_var9() %>"/></td>
	        	</tr> 
            </table>
	    </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>  	
    <tr>
        <td align='right'>
        		<input type="hidden" name="rc_no" value="<%=QfBean.getRc_no()%>">
				<button value="<%=QfBean.getRc_no()%>" style="float:right;" onclick="infoCan();" >닫기</button>
				<button onclick="updateQf();" value="<%=QfBean.getRc_no()%>" style="float:right;">저장</button>	
				<button onclick="deleteQf();" value="<%=QfBean.getRc_no()%>" style="float:right;">삭제</button>				
        </td>
    </tr>            
  </table>
</form>
</body>
</html>
