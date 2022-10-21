<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" 	scope="page" class="acar.forfeit_mng.FineGovBean"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
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
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	FineGovBn = FineDocDb.getFineGov(FineDocBn.getGov_id());
	//���ر�û������Ʈ
	Vector FineList = FineDocDb.getAccidMyDocLists(doc_id);
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	//����
	String u_var1 = e_db.getEstiSikVarCase("1", "", "myaccid_id1");//���μ���
	String u_var2 = e_db.getEstiSikVarCase("1", "", "myaccid_id2");	//�����
	String d_var1 = e_db.getEstiSikVarCase("1", "", "myaccid_app1");//÷�μ���1
	String d_var2 = e_db.getEstiSikVarCase("1", "", "myaccid_app2");//÷�μ���2
	String d_var3 = e_db.getEstiSikVarCase("1", "", "myaccid_app3");//÷�μ���3
	String d_var4 = e_db.getEstiSikVarCase("1", "", "myaccid_app4");//÷�μ���4	
	String d_var5 = e_db.getEstiSikVarCase("1", "", "myaccid_app5");//÷�μ���5
	String d_var6 = e_db.getEstiSikVarCase("1", "", "myaccid_app6");//÷�μ���6
	String d_var7 = e_db.getEstiSikVarCase("1", "", "myaccid_app7");//÷�μ���7
	String d_var8 = e_db.getEstiSikVarCase("1", "", "myaccid_app8");//÷�μ���8
	String d_var9 = e_db.getEstiSikVarCase("1", "", "myaccid_app9");//÷�μ���9
	String d_var10 = e_db.getEstiSikVarCase("1", "", "myaccid_app10");//÷�μ���10
	String d_var11 = e_db.getEstiSikVarCase("1", "", "myaccid_app11");//÷�μ���11
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "HEAD", "Y");
	int user_size = users.size();
	Vector users2 = c_db.getUserList("", "", "BODY", "Y");
	int user_size2 = users2.size();
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//�����ϱ�
	function fine_doc_upd(){	
		var fm = document.form1;
		
		if(fm.doc_id.value == '')		{ alert('������ȣ�� Ȯ���Ͻʽÿ�.'); return; }
		if(fm.doc_dt.value == '')		{ alert('�������ڸ� �Է��Ͻʽÿ�.'); return; }		
		if(fm.gov_id.value == '')		{ alert('���ű���� �����Ͻʽÿ�.'); return; }		
		if(fm.gov_nm.value == '')		{ alert('���ű���� �����Ͻʽÿ�.'); return; }

		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
		fm.action = "accid_mydoc_mng_u_a.jsp";
		fm.target = "i_no";
		fm.submit()
	}		
		

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='doc_id' value='<%=doc_id%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������ > <span class=style5>������û������ ����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line" colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width=12%>������ȣ</td>
                    <td width=88%>&nbsp;<%=FineDocBn.getDoc_id()%></td>
                </tr>
                <tr> 
                    <td class='title'>��������</td>
                    <td>&nbsp;<input type="text" name="doc_dt" size="11" class="text" value="<%=AddUtil.ChangeDate2(FineDocBn.getDoc_dt())%>" onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>
                      &nbsp;<input type="text" name="gov_nm" value='<%=FineDocBn.getGov_nm()%>' size="50" class="text" style='IME-MODE: active' onKeyDown='javascript:enter()'>
        			  <input type='hidden' name="gov_id" value='<%=FineDocBn.getGov_id()%>'>
                      
    			    </td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;<input type="text" name="mng_dept" value='<%=FineDocBn.getMng_dept()%>' size="50" class="text">
        			              (����ڸ� : 
                      <input name="mng_nm" type="text" value='<%=FineDocBn.getMng_nm()%>' class="text" size="10">
                      / ��������� : 
                      <input name="mng_pos" type="text" value='<%=FineDocBn.getMng_pos()%>' class="text" size="10">
                      )</td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;������ û��</td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;�� ���� ������ ������ ����մϴ�. </td>
                </tr>		  
                <tr> 
                    <td class='title'>÷��</td>
                    <td>
						<table cellspacing="2" cellpadding="2" border="0">
							<tr>
    							<td>&nbsp;&nbsp;&nbsp;&nbsp; �Ƹ���ī ����ڵ���� 1��
									&nbsp;&nbsp;&nbsp;&nbsp; �Ƹ���ī �ܱ�뿩���ǥ 1��
									&nbsp;&nbsp;&nbsp;&nbsp; �Ƹ���ī �������� ���� �纻 1��</td>
							</tr>
							<%		int s=0;
									String value[] = new String[11];
									
									if(!FineDocBn.getApp_docs().equals("")){
								  		StringTokenizer st = new StringTokenizer(FineDocBn.getApp_docs(),"^");
										
										while(st.hasMoreTokens()){
											value[s] = st.nextToken();
											s++;
										}
								  	}else{
										for(int i=0; i<11; i++){
											value[i] = "N";
										}
									}%>
							<tr>
							    <td>
								  <input type="checkbox" name="app_doc4"  value="Y" <%if(s>0 && value[3].equals("Y"))%>checked<%%>><%=d_var4%>
								  <input type="checkbox" name="app_doc5"  value="Y" <%if(s>0 && value[4].equals("Y"))%>checked<%%>><%=d_var5%>
								  <br>
								  <input type="checkbox" name="app_doc6"  value="Y" <%if(s>0 && value[5].equals("Y"))%>checked<%%>><%=d_var6%>
								  <input type="checkbox" name="app_doc7"  value="Y" <%if(s>0 && value[6].equals("Y"))%>checked<%%>><%=d_var7%>
								  <br>
								  <input type="checkbox" name="app_doc8"  value="Y" <%if(s>0 && value[7].equals("Y"))%>checked<%%>><%=d_var8%>
								  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="app_doc9"  value="Y" <%if(s>0 && value[8].equals("Y"))%>checked<%%>><%=d_var9%>
								  <br>
								  <input type="checkbox" name="app_doc10" value="Y" <%if(s>0 && value[9].equals("Y"))%>checked<%%>><%=d_var10%>
								  <input type="checkbox" name="app_doc11" value="Y" <%if(s>10 && value[10].equals("Y"))%>checked<%%>><%=d_var11%>
								  </td>
							</tr>
						</table>
                    </td>
                </tr>		
                <tr> 
                    <td class='title'>����ȣ</td>
                    <td>&nbsp;<input type="text" name="post_num" value='<%=FineDocBn.getPost_num()%>' class="text" size="30">
                </tr>	  		  
            </table>
        </td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���</span></td>
    </tr>
    <tr>     
        <td class=line2></td>    
    </tr>
    <tr>
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width=13% class='title'>���μ���</td>
                    <td width=37%><select name='h_mng_id' >
                        <option value="">����</option>
                        <%	if(user_size > 0){
            						for (int i = 0 ; i < user_size ; i++){
            							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(FineDocBn.getH_mng_id().equals((String)user.get("USER_ID")))%>selected<%%>><%=user.get("USER_NM")%></option>
                        <%		}
            					}		%>
                        </select></td>
                    <td  width=13% class='title'>�����</td>
                    <td width=37%><select name='b_mng_id' >
                        <option value="">����</option>
                        <%	if(user_size2 > 0){
            						for (int i = 0 ; i < user_size2 ; i++){
            							Hashtable user = (Hashtable)users2.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(FineDocBn.getB_mng_id().equals((String)user.get("USER_ID")))%>selected<%%>><%=user.get("USER_NM")%></option>
                        <%		}
            					}		%>
                        </select></td>
                </tr>
            </table>
        </td>
    </tr>		
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align="center">
	    <%if(!FineDocBn.getPrint_dt().equals("")){%>
	    <img src=/acar/images/center/arrow_printd.gif> : <%=AddUtil.ChangeDate2(FineDocBn.getPrint_dt())%>&nbsp;&nbsp;&nbsp;
	    <%}%>	    
	    <a href="javascript:fine_doc_upd();"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>	    
	    &nbsp;	    
	    <a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>	  
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
