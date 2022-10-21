<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.insa_card.*"%>
<%@ include file="/tax/cookies_base.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   

<%
	int rc_no=Integer.parseInt(request.getParameter("rc_no"));

	InsaRcDatabase icd = new InsaRcDatabase();
	Insa_Rc_BnBean bnBean=icd.InsaBnselectOne(rc_no);
	
	// 코드 리스트
	Vector vt_job = icd.getList("1");
	int vt_size = vt_job.size();
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<SCRIPT SRC="../lib/ckeditor/ckeditor.js"></SCRIPT>
<script language='javascript'>
	function infoCan(){ 
		opener.window.location='recruit_benefit_sc.jsp';
		close();
	}
	
	function deleteBn(){ 
		var theForm = document.form;
		if(!confirm('삭제하시겠습니까?')){		return;	}

		theForm.action = "recruit_benefit_up.jsp?gubun=d";		
		theForm.submit();
	}
	
	function updateBn(){ 
		var theForm = document.form;
		
		if ( theForm.rc_bene_st.value =="") { alert("직종을 선택하십시오."); return; }	
		
		if(!confirm('저장하시겠습니까?')){		return;	}				
		theForm.action = "recruit_benefit_up.jsp";
		theForm.submit();
	}
	
	
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form' method='post' target=''>
	<%@ include file="/include/search_hidden.jsp" %>
  	<table border="0" cellspacing="0" cellpadding="0" width="800">
	    <tr>
		    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>복리후생</span></td>
		</tr>
	    <tr>
	        <td class=h></td>
	    </tr>
		<tr><td class=line2></td></tr>
	    <tr>
        <td class="line" width='100%'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>   
				
	        	<tr>
	        		<td class='title' width='20%'>직종</th>
	        		<td width='80%'>&nbsp;
	        		  <select name='rc_bene_st'>	
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
		                <option value='<%=ht.get("RC_CODE")%>' <%if(bnBean.getRc_bene_st().equals((String)ht.get("RC_CODE"))){%>selected<%}%>><%= ht.get("RC_NM")%></option>
		                <%		}
							}%>
					<% } %>		
		              </select>
			        </td>	        		
	        	</tr>
	        	<tr>
	        		<td class='title' width='20%'>내용</th>
	        		<td width='80%'><textarea name="rc_bene_cont" cols='80' rows='18'><%=bnBean.getRc_bene_cont()==null?"":bnBean.getRc_bene_cont()%></textarea>
					<script>
					CKEDITOR.replace( 'rc_bene_cont', {
						toolbar: [
						    { name: 'links', items:['Link']},
						    { name: 'styles', items: [ 'Format', 'Font', 'FontSize' ] },
							{ name: 'basicstyles', items: [ 'Bold', 'Italic' ] },
							{ name: 'insert', items: ['Table','HorizontalRule'] },
							{ name: 'tools', items:['Maximize']}
						],
						height:"300px",
						enterMode: CKEDITOR.ENTER_DIV
					});
					</script>			</td>
	        	</tr> 
	        	
            </table>
	    </td>
    </tr>
    <tr>
        <td align='right'>
        		<input type="hidden" name="rc_no" value="<%=bnBean.getRc_no()%>">
				<button value="<%=bnBean.getRc_no()%>" style="float:right;" onclick="bnCan();" >닫기</button>
				<button onclick="updateBn();" value="<%=bnBean.getRc_no()%>" style="float:right;">저장</button>	
				<button onclick="deleteBn();" value="<%=bnBean.getRc_no()%>" style="float:right;">삭제</button>		
				
        </td>
    </tr>       	      
	</table>
  
</form>
</body>
</html>
