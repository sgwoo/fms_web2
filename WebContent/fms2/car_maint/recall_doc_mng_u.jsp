<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
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
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);

	
	//�����û����Ʈ
	Vector FineList = FineDocDb.getBankDocLists(doc_id);
					
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//����� ����Ʈ
	Vector users1 = c_db.getUserList("", "", "SACTION");
	int user_size1 = users1.size();	
%>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') fine_gov_search();
	}	
	
	
	//��Ϻ���
	function go_list(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "fine_doc_mng_frame.jsp";
		fm.submit();
	}			
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	
	
	//�����ϱ�
	function fine_doc_upd(){	
		var fm = document.form1;
		
	//	if(fm.doc_id.value == '')		{ alert('������ȣ�� Ȯ���Ͻʽÿ�.'); return; }
		if(fm.doc_dt.value == '')		{ alert('�������ڸ� �Է��Ͻʽÿ�.'); return; }		
		if(fm.print_dt.value == '')		{ alert('�������ڸ� �Է��Ͻʽÿ�.'); return; }		
		if(fm.f_reason.value == '')	{ alert('�������¸� �Է��Ͻʽÿ�.'); return; }
		if(fm.f_result.value == '')		{ alert('�������¸� �Է��Ͻʽÿ�.'); return; }
		
		if(fm.h_mng_id.value == '')		{ alert(' �������� �����ڸ� �����Ͻʽÿ�.'); return; }
		if(fm.b_mng_id.value == '')		{ alert('���ݴ������� �����ڸ� �����Ͻʽÿ�.'); return; }

		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
		fm.action = "recall_doc_mng_u_a.jsp";
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
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='doc_id' value='<%=doc_id%>'>
<input type='hidden' name='gov_id' value='<%=FineDocBn.getGov_id()%>'>
<input type='hidden' name='code' value='<%=FineDocBn.getMng_pos()%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>������ > �ڵ������� > <span class=style5>�ڵ������ݰ���</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr><td class=h></td></tr>
    <tr> 
        <td align="right"></td>
    </tr>
    <tr><td class=line2></td></tr>
    
        <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
           
                 <tr> 
                     <td class='title' width="10%"  rowspan=4>��������</td>
                    <td class='title'  >��������</td>
                    <td>&nbsp;<input type="text" name="doc_dt" size="11" class="text" value="<%=AddUtil.ChangeDate2(FineDocBn.getDoc_dt())%>" onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                     <td class='title'  width="10%" rowspan=4 >���ݴ�������</td>
                     <td class='title'  >��������</td>
                    <td>&nbsp;<input type="text" name="print_dt" size="11" class="text" value="<%=AddUtil.ChangeDate2(FineDocBn.getPrint_dt())%>" onBlur='javscript:this.value = ChangeDate(this.value);'></td> 
                </tr>
                 <tr> 
                    <td class='title' >��������</td>
                    <td>&nbsp; 
                      	<select name="f_reason" >
			    <option value="">---����---</option>
			    <option value="1" <%if(FineDocBn.getF_reason().equals("1"))%>selected<%%>>����</option>          
			    <option value="2" <%if(FineDocBn.getF_reason().equals("2"))%>selected<%%>>��ȭ</option>          
			    <option value="3" <%if(FineDocBn.getF_reason().equals("3"))%>selected<%%>>��Ÿ</option>      
			   </select>       
                    </td>
                        <td class='title' >��������</td>
                    <td>&nbsp; 
                     	<select name="f_result" >
			    <option value="">---����---</option>
			    <option value="1" <%if(FineDocBn.getF_result().equals("1"))%>selected<%%>>FMS����</option>          
			    <option value="2" <%if(FineDocBn.getF_result().equals("2"))%>selected<%%>>����</option>          
			    <option value="3" <%if(FineDocBn.getF_result().equals("3"))%>selected<%%>>��ȭ</option>      
			    <option value="4" <%if(FineDocBn.getF_result().equals("4"))%>selected<%%>>����</option>          
			    <option value="5" <%if(FineDocBn.getF_result().equals("5"))%>selected<%%>>��Ÿ</option>      			    
			   </select>       
                    </td>
                </tr>
                 <tr> 
                    <td class='title' >�����</td>
                    <td>&nbsp; 
                            <select name='reg_id'>
		                <option value="">����</option>
		                <%	if(user_size > 0){
								for(int i = 0 ; i < user_size ; i++){
									Hashtable user = (Hashtable)users.elementAt(i); %>
		                  <option value='<%=user.get("USER_ID")%>' <%if(FineDocBn.getReg_id().equals((String)user.get("USER_ID")))%>selected<%%>><%=user.get("USER_NM")%></option>
		                  
		                <%		}
							}%>
		              </select>
                    </td>
                        <td class='title' >�����</td>
                    <td>&nbsp; 
                    	  <select name='print_id'>
		                <option value="">����</option>
		                <%	if(user_size > 0){
								for(int i = 0 ; i < user_size ; i++){
									Hashtable user = (Hashtable)users.elementAt(i); %>
		                   <option value='<%=user.get("USER_ID")%>' <%if(FineDocBn.getPrint_id().equals((String)user.get("USER_ID")))%>selected<%%>><%=user.get("USER_NM")%></option>
		  
		                <%		}
							}%>
		              </select>	
                    </td>
                </tr>
                 <tr> 
                    <td class='title' >������</td>
                    <td>&nbsp; 
                     <select name='h_mng_id'>
		                <option value="">����</option>
		                <%	if(user_size1 > 0){
								for(int i = 0 ; i < user_size1 ; i++){
									Hashtable user1 = (Hashtable)users1.elementAt(i); %>
			       <option value='<%=user1.get("USER_ID")%>' <%if(FineDocBn.getH_mng_id().equals((String)user1.get("USER_ID")))%>selected<%%>><%=user1.get("USER_NM")%></option>
		                		  
		                <%		}
							}%>
		              </select>	
                        </td>
                        <td class='title' >������</td>
                    <td>&nbsp; 
                   <select name='b_mng_id'>
		                <option value="">����</option>
		                <%	if(user_size1 > 0){
								for(int i = 0 ; i < user_size1 ; i++){
									Hashtable user1 = (Hashtable)users1.elementAt(i); %>
			      <option value='<%=user1.get("USER_ID")%>' <%if(FineDocBn.getB_mng_id().equals((String)user1.get("USER_ID")))%>selected<%%>><%=user1.get("USER_NM")%></option>						
		            		  
		                <%		}
							}%>
		              </select>	
                    </td>
                </tr>
              </table>
           </td>
      </tr>          
     
          <tr>
        <td class=h></td>
    </tR>
    <tr>
    	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ݳ���</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
   
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
             <tr> 
                    <td  width="10%" class='title'>������</td>
                    <td  width="20%">&nbsp;<%=c_db.getNameById(FineDocBn.getGov_id(),"CAR_COM")%></td>
        		 <td width="11%"  class='title'>����</td>
                    <td  width="20%"> &nbsp;<%=c_db.getNameById(FineDocBn.getGov_id()+FineDocBn.getMng_pos(),"CAR_MNG")%> </td>                 	
                    <td  width="11%" class='title'>�𵨸�</td>
                    <td>&nbsp;<input type="text" name="mng_nm" value='<%=FineDocBn.getMng_nm()%>' size="40" class="text"> </td> 
                </tr>                
                  <tr> 
                    <td  width="10%"  class='title'>��󱸺�</td>
                    <td > &nbsp;  
                    	<select name="gov_st" >
                               <option value="">---����---</option>
                               <option value="1" <%if(FineDocBn.getGov_st().equals("1"))%>selected<%%>>��������</option>          
                               <option value="2" <%if(FineDocBn.getGov_st().equals("2"))%>selected<%%>>�ɼ�</option>    
			</select>   		         
                     </td>
                        <td width="11%"  class='title'>������(��������)</td>
                 	     <td> &nbsp;<input type="text" name="s_dt" size="11" class="text" value="<%=AddUtil.ChangeDate2(FineDocBn.getS_dt())%>" onBlur='javscript:this.value = ChangeDate(this.value);'></td>   
                        <td  width="11%"   class='title'>������(��������)</td>              
                        <td> &nbsp;<input type="text" name="e_dt" size="11" class="text" value="<%=AddUtil.ChangeDate2(FineDocBn.getE_dt())%>" onBlur='javscript:this.value = ChangeDate(this.value);'></td>              
                </tr>      
           </table>
       </td>
   </tr>        
   <tr>
        <td class=h></td>
    </tR>

    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
                  <tr> 
                    <td width="10%" class='title'>����Ⱓ</td>
                    <td  colspan=3>&nbsp;<input type="text" name="ip_dt" size="11" class="text" value="<%=AddUtil.ChangeDate2(FineDocBn.getIp_dt())%>" onBlur='javscript:this.value = ChangeDate(this.value);'>&nbsp;~&nbsp;  <input type="text" name="end_dt" size="11" class="text" value="<%=AddUtil.ChangeDate2(FineDocBn.getEnd_dt())%>" onBlur='javscript:this.value = ChangeDate(this.value);'> </td> 
                </tr>     
               <tr> 
                    <td width="10%" class='title'>���ݹ��</td>
                    <td  colspan=3> &nbsp;<input type="text" name="mng_dept" value='<%=FineDocBn.getMng_dept()%>' size="140" class="text"></td>   
               </tr>       
                <tr> 
                    <td  width="10%" class='title'>����ó��ó</td>
               	  <td  colspan=3>&nbsp;<input type="text" name="title" value='<%=FineDocBn.getTitle()%>' size="140" class="text"></td>   
                </tr>
                <tr> 
                    <td width="10%" class='title' style='height:38'>���Գ���</td>
             	   <td  colspan=3>&nbsp; 
             	     <textarea name="remarks" cols="140" class="text" style="IME-MODE: active" rows="2"><%=FineDocBn.getRemarks()%></textarea>                   
                    </td>                      
                </tr>            
            </table>
      </td>
    </tr>
         
    <tr>
        <td></td>
    </tr>

   
    <tr> 
        <td align="right">
	    <a href="javascript:fine_doc_upd();"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>
	    &nbsp;<a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>	  
	    </td>
    </tr>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
