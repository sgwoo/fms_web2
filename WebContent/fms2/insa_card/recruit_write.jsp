<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.common.*, acar.util.*, acar.user_mng.*, acar.insa_card.*"%>
<jsp:useBean id="br_bean" class="acar.user_mng.BranchBean" scope="page"/>
<%@ include file="/tax/cookies_base.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   

<%
	int rc_no=Integer.parseInt(request.getParameter("rc_no")==null?"0":request.getParameter("rc_no"));

	InsaRcDatabase icd = new InsaRcDatabase();
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();

	Insa_Rc_rcBean dto = icd.InsaRecselectOne(rc_no);
	
	List<Insa_Rc_JobBean> list1=icd.selectInsaRcJobAll();
	List<Insa_Rc_QfBean> list2=icd.selectInsaAllQf();

	//공급자
	Hashtable br = new Hashtable();
	
	//직무내용
	Insa_Rc_JobBean JbBean = new Insa_Rc_JobBean();
	
	//지원자격
	Insa_Rc_QfBean QfBean = new Insa_Rc_QfBean();
	
	String content1 = ""; 
			
	if(rc_no >0 ){
		br = c_db.getBranch2(dto.getRc_branch().trim());
		JbBean = icd.InsaRcJobselectOne2(dto.getRc_type());
		QfBean = icd.InsaQfselectOne2(dto.getRc_edu());
		content1 = JbBean.getRc_job_cont();
		if(!content1.contains("<div>")){ //신규 에디터로 작성한 내용이 아니면 \r\n 값을 <br/>태그로 치환함
			content1 = content1.replaceAll("\r\n","<br/>");
		}		
	}
	
	BranchBean br_r [] = umd.getBranchAll();
		
	// 코드 리스트
	Vector vt_job = icd.getList("1");  //직종
	int vt_size = vt_job.size();
	
	Vector vt_job2 = icd.getList("2");  //학력 
	int vt_size2 = vt_job2.size();
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function infoCan(){ 
	
		opener.window.location='recruit_notice_sc.jsp';
		
		close();
	}
	
	function deleteRc(){ 
		var theForm = document.form;
		if(!confirm('삭제하시겠습니까?')){		return;	}
	
		theForm.action = "recruit_write_up.jsp?gubun=d";
		theForm.submit();
	}
	
	function updateRc(){ 
		var theForm = document.form;
		
		if ( theForm.rc_type.value =="") { alert("직종을 선택하십시오."); return; }	
		//if ( theForm.rc_branch.value =="") { alert("근무예정지를 선택하십시오."); return; }
		if ( theForm.rc_edu.value =="") { alert("학력조건을 선택하십시오."); return; }
		if ( theForm.rc_apl_ed_dt.value =="") { alert("접수마감일을 선택하십시오."); return; }
		if ( theForm.rc_type.value =="") { alert("직종을 선택하십시오."); return; }
		
		
		if(!confirm('저장하시겠습니까?')){		return;	}
				
		theForm.action = "recruit_write_up.jsp";
		theForm.submit();
	}
//-->	
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form'class="form" method='post' target='qfList'>
<%@ include file="/include/search_hidden.jsp" %>

  <table border="0" cellspacing="0" cellpadding="0" width="800">
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>모집요강</span></td>
	</tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr><td class=line2></td></tr>
    <tr>
        <td class="line" width='100%'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>   
				
	        	<tr>
	        		<td class='title' width='20%'>모집직종</th>
	        		<td width='80%'>&nbsp;
	        		  <select name='rc_type'>	
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
		                <option value='<%=ht.get("RC_CODE")%>' <%if(dto.getRc_type().equals((String)ht.get("RC_CODE"))){%>selected<%}%>><%= ht.get("RC_NM")%></option>
		                <%		}
							}%>
					<% } %>		
		              </select>	        		
                    </td>	        		
	        	</tr>
	        	<tr>
	        		<td class='title' width='20%'>채용인원</th>
	        		<td width='80%'>&nbsp;<input type="text" name="rc_hire_per" size='5' class='num' value="<%=dto.getRc_hire_per()%>"/>명</td>
	        	</tr> 	
	        	<tr>
	        		<td class='title' width='20%'>근무예정지</th>
	        		<td width='80%'>&nbsp;<select name='rc_branch'>
                              <option value="수도권">수도권</option>
                              <%for(int i=0; i<br_r.length; i++){
        							br_bean = br_r[i];
        							if(br_bean.getBr_nm().equals("파주영업소") || br_bean.getBr_nm().equals("포천영업소") || br_bean.getBr_nm().equals("울산지점")) continue;
        					  %>
                              	<%if(rc_no >0 ){ %>
                              	<option value="<%=br_bean.getBr_nm()%>" <%if(dto.getRc_branch().equals(br_bean.getBr_nm())){%>selected<%}%>><%=br_bean.getBr_nm()%></option>
                              	<%}else{ %>
                              	<option value="<%=br_bean.getBr_nm()%>"><%=br_bean.getBr_nm()%></option>
                              	<%} %>
                              <%} %>
                            </select>
                    </td>	        		
	        	</tr>       
	        	<tr>
	        		<td class='title' width='20%'>학력조건</th>
	        		<td width='80%'>&nbsp;<select name='rc_edu'>
	        			  <% //신규등록이면 
	        		  if ( rc_no == 0 ) { %>
	        		    <option value="">--선택--</option>
	        		  <%	if(vt_size2 > 0){
								for(int i = 0 ; i < vt_size2 ; i++){
									Hashtable ht2 = (Hashtable)vt_job2.elementAt(i); %>
		                <option value='<%=ht2.get("RC_CODE")%>'> <%= ht2.get("RC_NM")%></option>
		                <%		}
							}%>
	        		 <% } else { %> 
	        		  
		                <%	if(vt_size2 > 0){
								for(int i = 0 ; i < vt_size2 ; i++){
									Hashtable ht2 = (Hashtable)vt_job2.elementAt(i); %>
		                <option value='<%=ht2.get("RC_CODE")%>' <%if(dto.getRc_edu().equals((String)ht2.get("RC_CODE"))){%>selected<%}%>><%= ht2.get("RC_NM")%></option>
		                <%		}
							}%>
					<% } %>		
		              </select>	       		
		              	        	
                    </td>	        		
	        	</tr>   	        	
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
					<td  name="rc_apl_ed_dt">&nbsp;<input type="text" name="rc_apl_ed_dt" size='12' value="<%=dto.getRc_apl_ed_dt()==null?"":AddUtil.ChangeDate2(dto.getRc_apl_ed_dt())%>"/></td> 
				</tr>
				<tr>
					<td class="title" width='20%'>합격자발표일</td> 
					<td  name="rc_pass_dt">&nbsp;<input type="text" name="rc_pass_dt" size='12' value="<%=dto.getRc_pass_dt()==null?"":AddUtil.ChangeDate2(dto.getRc_pass_dt())%>"/></td> 
				</tr>
				<tr>
					<td class="title" width='20%'>전형방법</td> 
					<td  name="rc_apl_mat">&nbsp;<input type="text" name="rc_apl_mat" size='40' value="<%=dto.getRc_apl_mat()==null?"":dto.getRc_apl_mat()%>"/></td> 
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
					<td  >&nbsp;이력서, 자기소개서, 졸업증명서, 기타(본인에게 유리한 모든 서류)</td> 
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
					<td >&nbsp;<input type="text" name="rc_manager" size='20' value="<%=dto.getRc_manager()==null?"":dto.getRc_manager()%>"/></td> 
				</tr>
				<tr>
					<td class="title" width='20%'>연락처</td> 
					<td >&nbsp;<input type="text" name="rc_tel" size='20' value="<%=dto.getRc_tel()==null?"":dto.getRc_tel()%>"/></td> 
				</tr>				
			</table>
	    </td>
    </tr>        
    <tr> 
        <td class=h></td>
    </tr>  	
    <tr>
        <td align='right'>
        		<input type="hidden" name="rc_no" value="<%=dto.getRc_no()%>">
				<button value="<%=dto.getRc_no()%>" style="float:right;" onclick="infoCan();" >닫기</button>
				<button onclick="updateRc();" value="<%=dto.getRc_no()%>" style="float:right;">저장</button>&nbsp;&nbsp;	
				<button onclick="deleteRc();" value="<%=dto.getRc_no()%>" style="float:right;">삭제</button>&nbsp;&nbsp;	
							
        </td>
    </tr>            
  </table>
</form>
</body>
</html>