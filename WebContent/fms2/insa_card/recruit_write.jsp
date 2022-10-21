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

	//������
	Hashtable br = new Hashtable();
	
	//��������
	Insa_Rc_JobBean JbBean = new Insa_Rc_JobBean();
	
	//�����ڰ�
	Insa_Rc_QfBean QfBean = new Insa_Rc_QfBean();
	
	String content1 = ""; 
			
	if(rc_no >0 ){
		br = c_db.getBranch2(dto.getRc_branch().trim());
		JbBean = icd.InsaRcJobselectOne2(dto.getRc_type());
		QfBean = icd.InsaQfselectOne2(dto.getRc_edu());
		content1 = JbBean.getRc_job_cont();
		if(!content1.contains("<div>")){ //�ű� �����ͷ� �ۼ��� ������ �ƴϸ� \r\n ���� <br/>�±׷� ġȯ��
			content1 = content1.replaceAll("\r\n","<br/>");
		}		
	}
	
	BranchBean br_r [] = umd.getBranchAll();
		
	// �ڵ� ����Ʈ
	Vector vt_job = icd.getList("1");  //����
	int vt_size = vt_job.size();
	
	Vector vt_job2 = icd.getList("2");  //�з� 
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
		if(!confirm('�����Ͻðڽ��ϱ�?')){		return;	}
	
		theForm.action = "recruit_write_up.jsp?gubun=d";
		theForm.submit();
	}
	
	function updateRc(){ 
		var theForm = document.form;
		
		if ( theForm.rc_type.value =="") { alert("������ �����Ͻʽÿ�."); return; }	
		//if ( theForm.rc_branch.value =="") { alert("�ٹ��������� �����Ͻʽÿ�."); return; }
		if ( theForm.rc_edu.value =="") { alert("�з������� �����Ͻʽÿ�."); return; }
		if ( theForm.rc_apl_ed_dt.value =="") { alert("������������ �����Ͻʽÿ�."); return; }
		if ( theForm.rc_type.value =="") { alert("������ �����Ͻʽÿ�."); return; }
		
		
		if(!confirm('�����Ͻðڽ��ϱ�?')){		return;	}
				
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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����䰭</span></td>
	</tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr><td class=line2></td></tr>
    <tr>
        <td class="line" width='100%'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>   
				
	        	<tr>
	        		<td class='title' width='20%'>��������</th>
	        		<td width='80%'>&nbsp;
	        		  <select name='rc_type'>	
	        		  <% //�űԵ���̸� 
	        		  if ( rc_no == 0 ) { %>
	        		    <option value="">--����--</option>
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
	        		<td class='title' width='20%'>ä���ο�</th>
	        		<td width='80%'>&nbsp;<input type="text" name="rc_hire_per" size='5' class='num' value="<%=dto.getRc_hire_per()%>"/>��</td>
	        	</tr> 	
	        	<tr>
	        		<td class='title' width='20%'>�ٹ�������</th>
	        		<td width='80%'>&nbsp;<select name='rc_branch'>
                              <option value="������">������</option>
                              <%for(int i=0; i<br_r.length; i++){
        							br_bean = br_r[i];
        							if(br_bean.getBr_nm().equals("���ֿ�����") || br_bean.getBr_nm().equals("��õ������") || br_bean.getBr_nm().equals("�������")) continue;
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
	        		<td class='title' width='20%'>�з�����</th>
	        		<td width='80%'>&nbsp;<select name='rc_edu'>
	        			  <% //�űԵ���̸� 
	        		  if ( rc_no == 0 ) { %>
	        		    <option value="">--����--</option>
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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" width='100%' >
			<table border="0" cellspacing="1" cellpadding="0" width='100%'> 
				<tr>
					<td class="title" width='20%'>����������</td> 
					<td  name="rc_apl_ed_dt">&nbsp;<input type="text" name="rc_apl_ed_dt" size='12' value="<%=dto.getRc_apl_ed_dt()==null?"":AddUtil.ChangeDate2(dto.getRc_apl_ed_dt())%>"/></td> 
				</tr>
				<tr>
					<td class="title" width='20%'>�հ��ڹ�ǥ��</td> 
					<td  name="rc_pass_dt">&nbsp;<input type="text" name="rc_pass_dt" size='12' value="<%=dto.getRc_pass_dt()==null?"":AddUtil.ChangeDate2(dto.getRc_pass_dt())%>"/></td> 
				</tr>
				<tr>
					<td class="title" width='20%'>�������</td> 
					<td  name="rc_apl_mat">&nbsp;<input type="text" name="rc_apl_mat" size='40' value="<%=dto.getRc_apl_mat()==null?"":dto.getRc_apl_mat()%>"/></td> 
				</tr>
				<tr>
					<td class="title" width='20%'>�������</td> 
					<td >&nbsp;E-Mail (���� �� �������� �ȵ�)</td> 
				</tr>
				<tr>
					<td class="title" width='20%'>����ó</td> 
					<td >&nbsp;recruit@amazoncar.co.kr</td> 
				</tr>
				<tr>
					<td class="title" width='20%'>���⼭��</td> 
					<td  >&nbsp;�̷¼�, �ڱ�Ұ���, ��������, ��Ÿ(���ο��� ������ ��� ����)</td> 
				</tr>
			</table>
	    </td>
    </tr>
	<tr> 
        <td class=h></td>
    </tr>  	      
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ä������</span></td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" width='100%' >
			<table border="0" cellspacing="1" cellpadding="0" width='100%'> 
				<tr>
					<td class="title" width='20%'>�����</td> 
					<td >&nbsp;<input type="text" name="rc_manager" size='20' value="<%=dto.getRc_manager()==null?"":dto.getRc_manager()%>"/></td> 
				</tr>
				<tr>
					<td class="title" width='20%'>����ó</td> 
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
				<button value="<%=dto.getRc_no()%>" style="float:right;" onclick="infoCan();" >�ݱ�</button>
				<button onclick="updateRc();" value="<%=dto.getRc_no()%>" style="float:right;">����</button>&nbsp;&nbsp;	
				<button onclick="deleteRc();" value="<%=dto.getRc_no()%>" style="float:right;">����</button>&nbsp;&nbsp;	
							
        </td>
    </tr>            
  </table>
</form>
</body>
</html>