<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*, acar.client.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/agent/cookies.jsp" %>
 	
<%
	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup ��û�� ������
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");

	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
		
	ClientBean client = al_db.getNewClient(client_id);
	
%>	
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//��ϰ���	
	function go_to_list()
	{
		var fm = document.form1;
		var s_kd = fm.s_kd.value;
		var t_wd = fm.t_wd.value;
		var asc = fm.asc.value;
		location='/agent/client/client_s_frame.jsp?s_kd='+s_kd+'&t_wd='+t_wd+'&asc='+asc;
	}
	
	//����������̷�
	function cl_enp_h(client_id, firm_nm)
	{
		var fm = document.form1;
		window.open("about:blank", "CLIENT_ENP", "left=50, top=50, width=1000, height=600, resizable=yes, scrollbars=yes, status=yes");				
		fm.action = "/agent/client/client_enp_p.jsp";
		fm.target = "CLIENT_ENP";
		fm.submit();
	}	

	//����/�������
	function cl_site(client_id, firm_nm)
	{
		window.open('/agent/client/client_site_s_p.jsp?client_id='+client_id+'&firm_nm='+firm_nm, "CLIENT_SITE", "left=100, top=100, width=650, height=500, resizable=yes, scrollbars=yes, status=yes");
	}
		
	//�繫��ǥ
	function cl_fin(client_id, firm_nm)
	{
		window.open('/agent/client/client_fin_s_p.jsp?client_id='+client_id+'&firm_nm='+firm_nm, "CLIENT_SITE", "left=100, top=100, width=750, height=500, resizable=yes, scrollbars=yes, status=yes");
	}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>


<body>
<form name='form1' method='post'>

<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='firm_nm' value='<%=client.getFirm_nm()%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td colspan="2">
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>������</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;
	    <font color="#999999">
        <img src=/acar/images/center/arrow_ccdrj.gif align=absmiddle> : <%=c_db.getNameById(client.getReg_id(), "USER")%>&nbsp;&nbsp; <img src=/acar/images/center/arrow_ccdri.gif align=absmiddle> :
            <%=AddUtil.ChangeDate2(client.getReg_dt())%>
    		&nbsp;&nbsp;
            <img src=/acar/images/center/arrow_cjsjj.gif align=absmiddle> : <%=c_db.getNameById(client.getUpdate_id(), "USER")%>&nbsp;&nbsp; <img src=/acar/images/center/arrow_cjsji.gif align=absmiddle> : 
            <%=AddUtil.ChangeDate2(client.getUpdate_dt())%>
            </font> 
        </td>
        <td align='right'>
    	    <%	if(from_page.equals("")){%>
            &nbsp;&nbsp;<a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a> 
            <%	}%>		
	    </td>
    </tr> 
    <tr>
        <td class=line2 colspan=2></td>
    </tr>         
    <tr> 
        <td colspan="2" class='line'>
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title' width='13%'>������</td>
                    <td>&nbsp; 
                      <%if(client.getClient_st().equals("1")) 		out.println("����");
                      	else if(client.getClient_st().equals("2"))  out.println("����");
                      	else if(client.getClient_st().equals("3")) 	out.println("���λ����(�Ϲݰ���)");
                      	else if(client.getClient_st().equals("4"))	out.println("���λ����(���̰���)");
                      	else if(client.getClient_st().equals("5")) 	out.println("���λ����(�鼼�����)");
        				else if(client.getClient_st().equals("6")) 	out.println("�����");%>
						&nbsp; 
						<%=client_id%>
                    </td>
                </tr>
            </table>
        </td>
	</tr>   
	<tr>
	    <td class=h></td>
	</tr> 
    <tr id=tr_acct1 style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>">  
        <td colspan="2">
    	    <table border="0" cellspacing="0" cellpadding="0" width=100%> 
    		    <tr>	
    			    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����</span></td>
    		    </tr>
    		    <tr>
    		        <td class=line2></td>
    		    </tr>
    		    <tr>
    			    <td class=line>
    			        <table border="0" cellspacing="1" cellpadding="0" width=100%>
            		        <tr>
            		            <td colspan="2" class='title'>���αԸ�</td>
            		            <td>&nbsp;
                			        <%if(client.getFirm_st().equals("1")) 		out.println("����");
                	               	else if(client.getFirm_st().equals("2"))	out.println("�߱��");
                					else if(client.getFirm_st().equals("3"))	out.println("�ұ��");
                					else if(client.getFirm_st().equals("4"))	out.println("ũ��ž�̵���");%>
                	               	&nbsp;<%if(client.getEnp_yn().equals("Y")) 	out.println("����");%> 
                				    &nbsp;<%= client.getEnp_nm()%> &nbsp;<%if(client.getEnp_yn().equals("Y")) 	out.println("�迭��");%> 
            				    </td>            			
            		            <td class='title'>��������</td>
            		            <td>&nbsp;
            		             <%if(client.getFirm_type().equals("1")) 		out.println("�������ǽ���");
            	              	 else if(client.getFirm_type().equals("2")) 	out.println("�ڽ��ڻ���");
            	              	 else if(client.getFirm_type().equals("3"))   	out.println("�ܰ�����");
            	              	 else if(client.getFirm_type().equals("4"))   	out.println("��ó���");
            	              	 else if(client.getFirm_type().equals("5"))   	out.println("�Ϲݹ���");
            	              	 else if(client.getFirm_type().equals("6"))   	out.println("����");
            	              	 else if(client.getFirm_type().equals("7"))   	out.println("������ġ��ü");
            	              	 else if(client.getFirm_type().equals("8"))   	out.println("�������ڱ��");
            	              	 else if(client.getFirm_type().equals("9"))		out.println("�����⿬�������");
								 else if(client.getFirm_type().equals("10"))	out.println("�񿵸�����");
								 else if(client.getFirm_type().equals("11"))	out.println("�鼼����");
								 %>
            	                </td>
            		        </tr>
            		        <tr>
            		            <td colspan="2" class='title'>��������</td>
            		            <td>&nbsp;
            		                <%= client.getFound_year()%></td>
            		            <td class='title'>��������</td>
            		            <td>&nbsp;
            		                <%= client.getOpen_year()%></td>
            		        </tr>
            		        <tr>
            		            <td width='3%' rowspan="5" class='title'>��<br>
                					��<br>
                					��<br>
                					��<br>
                					��<br>
                					��</td>
            		            <td width="10%" class='title'>��ȣ</td>
            		            <td width="37%" align='left'>&nbsp;<%=client.getFirm_nm()%></td>
            		            <td class='title' width=13%>��ǥ��</td>
            		            <td width="37%">&nbsp;<%=client.getClient_nm()%></td>
            		        </tr>
            		        <tr>
            		            <td class='title'>����ڹ�ȣ<br/>
            		            </td>
            		            <td>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%>
								<%if(!client.getTaxregno().equals("")){%>
								(������ڹ�ȣ:<%=client.getTaxregno()%>)
								<%}%>
								</td>
            		            <td class='title'>���ι�ȣ</td>
            		            <td>&nbsp;<%=client.getSsn1()%>-<%=client.getSsn2()%></td>
            		        </tr>
            		        <tr>
            		            <td class='title'>����� �ּ�</td>
            		            <td colspan='3'>
                        		              <%if(!client.getO_addr().equals("")){%>
                        		              ( 
                        		              <%}%>
                        		              <%=client.getO_zip()%> 
                        		              <%if(!client.getO_addr().equals("")){%>
                        		              )&nbsp; 
                        		              <%}%>
                        		              <%=client.getO_addr()%>
                        		</td>
            		        </tr>									
            		        <tr>
            		            <td class='title'>����������</td>
            		            <td colspan='3'>&nbsp;
            		            <%if(!client.getHo_addr().equals("")){%>
            		              ( 
            		              <%}%>
            		              <%=client.getHo_zip()%> 
            		              <%if(!client.getHo_addr().equals("")){%>
            		              )&nbsp; 
            		              <%}%>
            		              <%=client.getHo_addr()%>
            		            </td>
            		        </tr>
            		        <tr>
            		            <td class='title'>����</td>
            		            <td>&nbsp;<%=client.getBus_cdt()%></td>
            		            <td class='title'>����</td>
            		            <td>&nbsp;<%=client.getBus_itm()%></td>
            		        </tr>
            		        <tr>
            		            <td rowspan="4" class='title'>��<br>
                					ǥ<br>
                					��</td>
            		            <td class='title'>��ǥ�ڱ���</td>
            		            <td>&nbsp;
            			        <%if(client.getRepre_st().equals("1")) 		out.println("��������");
            	                   	else if(client.getRepre_st().equals("2"))	out.println("�����濵��");%>
            	                </td>
            		            <td class='title'>�������</td>
            		            <td>&nbsp;<%=client.getRepre_ssn1()%>-<%if(client.getRepre_ssn2().length() > 1){%><%=client.getRepre_ssn2().substring(0,1)%><%}%>******</td>				  
            				</tr>
            		        <tr>
            		            <td class='title'>�ּ�</td>
            		            <td colspan="3">
            		                <table width=100% border=0 cellspacing=0 cellpadding=3>
            		                    <tr>
            		                        <td>
                        		              <%if(!client.getRepre_addr().equals("")){%>
                        		              ( 
                        		              <%}%>
                        		              <%=client.getRepre_zip()%> 
                        		              <%if(!client.getRepre_addr().equals("")){%>
                        		              )&nbsp; 
                        		              <%}%>
                        		              <%=client.getRepre_addr()%>
                        		            </td>
                        		        </tr>
                        		    </table>
                        		</td>
            		        </tr>
            		        <tr>
            		            <td class='title'>�̸����ּ�</td>
            		            <td colspan="3">&nbsp;<%=client.getRepre_email()%></td>
            		        </tr>            		                    		        
            		        <tr>
            		            <td class='title'>�޴�����ȣ</td>
            		            <td>&nbsp;<%=AddUtil.phoneFormat(client.getM_tel())%></td>
            		            <td class='title'>���ù�ȣ</td>
            		            <td>&nbsp;<%=AddUtil.phoneFormat(client.getH_tel())%></td>
            		        </tr>
            		        <tr>
            		            <td colspan="2" class='title'>�繫�ǹ�ȣ</td>
            		            <td>&nbsp;<%=AddUtil.phoneFormat(client.getO_tel())%></td>
            		            <td class='title'>�ѽ���ȣ</td>
            		            <td>&nbsp;<%=AddUtil.phoneFormat(client.getFax())%></td>
            		        </tr>
            		        <tr>
            		            <td colspan="2" class='title'>Homepage</td>
            		            <td colspan="3">&nbsp;<a href='<%=client.getHomepage()%>' target='about:blank'><%=client.getHomepage()%></a></td>
            		        </tr>
    		            </table>
    			    </td>
    		    </tr>
        	</table>
	    </td>
    </tr>	  
    <tr id=tr_acct2 style="display:<%if(client.getClient_st().equals("1") || client.getClient_st().equals("2") ){%>none<%}else{%>''<%}%>">
	    <td colspan="2">
    	    <table border="0" cellspacing="0" cellpadding="0" width=100%> 
    		    <tr>
    			    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���λ����</span></td>
    		    </tr>
    		    <tr>
                    <td class=line2 colspan=2></td>
                </tr> 
    		    <tr>
    			    <td class=line>
    			        <table border="0" cellspacing="1" cellpadding="0" width=100%>
            		        <tr>
            		            <td width='3%' rowspan="5" class='title'>��<br>
                			      ��<br>
                			      ��<br>
                			      ��<br>
                		    	  ��<br>
                			      ��</td>
            		            <td class='title' width='10%'>��������� </td>
            		            <td colspan="3">&nbsp;<%= client.getOpen_year()%></td>
            		        </tr>
            		        <tr>
            		            <td class='title'>��ȣ</td>
            		            <td width="37%" align='left'>&nbsp;<%= client.getFirm_nm()%></td>
            		            <td class='title'>��ǥ��</td>
            		            <td width="37%">&nbsp;<%= client.getClient_nm()%></td>
            		        </tr>
            		        <tr>
            		            <td class='title'>����ڹ�ȣ<br/>
            		            </td>
            		            <td>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
            		            <td class='title'>�������</td>
            		            <td>&nbsp;<%=client.getSsn1()%>-<%if(client.getSsn2().length() > 1){%><%=client.getSsn2().substring(0,1)%><%}%>******</td>
            		        </tr>
            		        <tr>
            		            <td class='title'>����� ������</td>
            		            <td colspan='3'>&nbsp;
            		              <%if(!client.getO_addr().equals("")){%>
            		              ( 
            		              <%}%>
            		              <%=client.getO_zip()%> 
            		              <%if(!client.getO_addr().equals("")){%>
            		              )&nbsp; 
            		              <%}%>
            		              <%=client.getO_addr()%>
            		            </td>
            		        </tr>
            		        <tr>
            		            <td class='title'>����</td>
            		            <td>&nbsp;<%= client.getBus_cdt()%></td>
            		            <td class='title'>����</td>
            		            <td>&nbsp;<%= client.getBus_itm()%></td>
            		        </tr>            		     
            		        <tr>
            		            <td rowspan="4" class='title'>��<br>
            					ǥ<br>
            					��</td>
            					<td class='title'>��ǥ�ڱ���</td>
            					<td>&nbsp;
                		            <select name='repre_st'>
                		              <option value="">����</option>
                		              <option value="1">��������</option>
                		              <option value="2">�����濵��</option>
                		            </select>
                		            &nbsp;&nbsp;
                		            �̸� : <input type='text' size='10' name='repre_nm' value='' maxlength='50' class='text' value='' OnBlur="checkSpecial();">
                		            (������ǥ�� ������ ��� ��ǥ�� ����������)
                		            </td>
            		            <td class='title'>�������</td>
            		            <td>&nbsp;<%=client.getRepre_ssn1()%>-<%if(client.getRepre_ssn2().length() > 1){%><%=client.getRepre_ssn2().substring(0,1)%><%}%>******</td>
            		            </tr>
            		            <tr>
            		            <td class='title'>�ּ�</td>
            		            <td colspan="3">
            		                <table width=100% border=0 cellspacing=0 cellpadding=3>
            		                    <tr>
            		                        <td>
                        		              <%if(!client.getRepre_addr().equals("")){%>
                        		              ( 
                        		              <%}%>
                        		              <%=client.getRepre_zip()%> 
                        		              <%if(!client.getRepre_addr().equals("")){%>
                        		              )&nbsp; 
                        		              <%}%>
                        		              <%=client.getRepre_addr()%>
                        		            </td>
                        		        </tr>
                        		    </table>
                        		</td>
            				</tr>
            				<tr>
            		            <td class='title'>�̸����ּ�</td>
            		            <td colspan="3">&nbsp;<%=client.getRepre_email()%></td>
            		        </tr>
            		        <tr>
            		            <td class='title'>�޴�����ȣ</td>
            		            <td>&nbsp;<%=AddUtil.phoneFormat(client.getM_tel())%></td>
            		            <td class='title'>���ù�ȣ</td>
            		            <td>&nbsp;<%=AddUtil.phoneFormat(client.getH_tel())%></td>
            		        </tr>		     
            		        <tr>
            		            <td colspan="2" class='title'>�繫�ǹ�ȣ</td>
            		            <td>&nbsp;<%= client.getO_tel()%></td>
            		            <td class='title'>�ѽ���ȣ</td>
            		            <td>&nbsp;<%= client.getFax()%></td>
            		        </tr>
            		        <tr>
            		            <td colspan="2" class='title'>Homepage</td>
            		            <td colspan="3">&nbsp;<a href='<%=client.getHomepage()%>' target='about:blank'><%=client.getHomepage()%></a></td>
            		        </tr>
    		            </table>
    			    </td>
    		   </tr>
        	</table>
	    </td>
    </tr>	    
    <tr id=tr_acct3 style="display:<%if(client.getClient_st().equals("2")){%>''<%}else{%>none<%}%>"> 
	<td colspan="2">
	    <table border="0" cellspacing="0" cellpadding="0" width=100%> 	  
    		<tr>
    		    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����</span></td>
    		</tr>
    		<tr>
    		    <td class=line2></td>
    		</tr>
    		<tr>
    		    <td class=line>
        		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
        		        <tr>
        		            <td colspan="2" class='title'>����</td>
        		            <td align='left'>&nbsp;<%=client.getFirm_nm()%></td>
        		            <td class='title'>�������</td>
        		            <td>&nbsp;<%=client.getSsn1()%>-<%if(client.getSsn2().length() > 1){%><%=client.getSsn2().substring(0,1)%><%}%>******</td>
        		        </tr>
        		        <tr>
        		            <td colspan="2" class='title'>�����ּ�</td>
        		            <td colspan='3'>&nbsp;
        		         	  <%if(!client.getHo_addr().equals("")){%>
        		              ( 
        		              <%}%>
        		              <%=client.getHo_zip()%> 
        		              <%if(!client.getHo_addr().equals("")){%>
        		              )&nbsp; 
        		              <%}%>
        		              <%=client.getHo_addr()%>
        					    </td>
        		        </tr>
        		        <tr>
        		            <td colspan="2" class='title'>�޴���</td>
        		            <td>&nbsp;<%=AddUtil.phoneFormat(client.getM_tel())%></td>
        		            <td class='title'>������ȭ��ȣ</td>
        		            <td>&nbsp;<%=AddUtil.phoneFormat(client.getH_tel())%></td>
        		        </tr>
        		        <tr>
        		            <td colspan="2" class='title'>����</td>
        		            <td>&nbsp;<%if(client.getNationality().equals("2")) 		out.println("�ܱ���");
		            	               	else 											out.println("������");%></td>						
        		            <td class='title'>Homepage</td>
        		            <td>&nbsp;<a href='<%=client.getHomepage()%>' target='about:blank'><%=client.getHomepage()%></a></td>
        		        </tr>
        		        <tr>
        		            <td width="3%" rowspan="6" class='title'>��<br>
            		            ��<br>��<br>
            		            ��</td>
        		            <td width="10%" class='title'>����</td>
        		            <td width="37%">&nbsp;<%=client.getJob()%></td>
        		            <td width="13%" class='title'>�ҵ汸��</td>
        		            <td width="37%">&nbsp; 
            		            <%if(client.getPay_st().equals("1")) 		out.println("�޿��ҵ�");
            	              	else if(client.getPay_st().equals("2"))    out.println("����ҵ�");
            	               	else if(client.getPay_st().equals("3"))	out.println("��Ÿ����ҵ�");%>
        	                </td>
        		        </tr>
        		        <tr>
        		            <td class='title'>�����</td>
        		            <td colspan="3">&nbsp;<%=client.getCom_nm()%></td>
        		        </tr>
        		        <tr>
        		            <td class='title'>�μ���</td>
        		            <td>&nbsp;<%=client.getDept()%></td>
        		            <td class='title'>����</td>
        		            <td>&nbsp;<%=client.getTitle()%></td>
        		        </tr>
        		        <tr>
        		            <td class='title'>��ȭ��ȣ</td>
        		            <td>&nbsp;<%=AddUtil.phoneFormat(client.getO_tel())%></td>
        		            <td class='title'>FAX</td>
        		            <td>&nbsp;<%=AddUtil.phoneFormat(client.getFax())%></td>
        		        </tr>
        		        <tr>
        		            <td class='title'>�����ּ�</td>
        		            <td colspan="3">&nbsp;
        		            <%if(!client.getComm_addr().equals("")){%>
        		              ( 
        		              <%}%>
        		              <%=client.getComm_zip()%> 
        		              <%if(!client.getComm_addr().equals("")){%>
        		              )&nbsp; 
        		              <%}%>
        		              <%=client.getComm_addr()%>
        		            </td>   
        		        </tr>
        		        <tr>
        		            <td class='title'>�ټӿ���</td>
        		            <td>&nbsp;<%=client.getWk_year()%>��</td>
        		            <td class='title'>���ҵ�</td>
        		            <td>&nbsp;<%=client.getPay_type()%>����</td>
        		        </tr>
        		        <tr>
            		          <td rowspan="3" class='title'>��<br>
                					ǥ<br>
                					��</td>
            		            <td class='title'>��ǥ�ڱ���</td>
            		            <td>&nbsp;
            	                   �̸� : <%=client.getRepre_nm()%>	(����������)
            	                </td>
            		            <td class='title'>�������</td>
            		            <td>&nbsp;<%=client.getRepre_ssn1()%>-<%if(client.getRepre_ssn2().length() > 1){%><%=client.getRepre_ssn2().substring(0,1)%><%}%>******</td>				  
            				</tr>
            		        <tr>
            		            <td class='title'>�ּ�</td>
            		            <td colspan="3">
            		                <table width=100% border=0 cellspacing=0 cellpadding=3>
            		                    <tr>
            		                        <td>
                        		              <%if(!client.getRepre_addr().equals("")){%>
                        		              ( 
                        		              <%}%>
                        		              <%=client.getRepre_zip()%> 
                        		              <%if(!client.getRepre_addr().equals("")){%>
                        		              )&nbsp; 
                        		              <%}%>
                        		              <%=client.getRepre_addr()%>
                        		            </td>
                        		        </tr>
                        		    </table>
                        		</td>
            		        </tr>
            		        <tr>
            		            <td class='title'>�̸����ּ�</td>
            		            <td colspan="3">&nbsp;<%=client.getRepre_email()%></td>
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
	    <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����</span></td>
    </tr>
    <tr>
	    <td class=line2 colspan="2"></td>
	</tr>  
	<tr>
	    <td colspan="2" class=line>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
	        	    <tr>
                    <td class='title'>���������ȣ</td>
                    <td colspan="3">&nbsp;<%=client.getLic_no()%></td>
                </tr>		
                <tr>
                    <td width="15%" rowspan='2' class='title'>���ݰ�꼭<br>
                        ���Ŵ����</td>
                    <td colspan='3'>&nbsp;����:<%=client.getCon_agnt_nm()%>
        			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�繫��:<%=AddUtil.phoneFormat(client.getCon_agnt_o_tel())%>
        			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�̵���ȭ:<%=AddUtil.phoneFormat(client.getCon_agnt_m_tel())%>
        			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FAX:<%=AddUtil.phoneFormat(client.getCon_agnt_fax())%>
        		    </td>
                </tr>
                <tr>
                    <td colspan='3'>&nbsp;EMAIL:<%=client.getCon_agnt_email()%>
        			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ٹ��μ�:<%=client.getCon_agnt_dept()%>
        			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����:<%=client.getCon_agnt_title()%>
                    </td>
                </tr>
                <tr>
                    <td width="15%" rowspan='2' class='title'>���ݰ�꼭<br>
                        �߰������</td>
                    <td colspan='3'>&nbsp;����:<%=client.getCon_agnt_nm2()%>
        			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�繫��:<%=AddUtil.phoneFormat(client.getCon_agnt_o_tel2())%>
        			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�̵���ȭ:<%=AddUtil.phoneFormat(client.getCon_agnt_m_tel2())%>
        			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FAX:<%=AddUtil.phoneFormat(client.getCon_agnt_fax2())%>
        		    </td>
                </tr>
                <tr>
                    <td colspan='3'>&nbsp;EMAIL:<%=client.getCon_agnt_email2()%>
        			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ٹ��μ�:<%=client.getCon_agnt_dept2()%>
        			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����:<%=client.getCon_agnt_title2()%>
                    </td>
                </tr>                       
                <tr>
                    <td class='title'>�̸��ϼ��Űźλ���</td>
                    <td colspan="3">&nbsp;<%=client.getEtax_not_cau()%></td>
                </tr>	
                <tr>
                    <td class='title'>�ŷ��������ϼ��ſ���</td>
                    <td width="35%">&nbsp;
                     <%  if(client.getItem_mail_yn().equals("N")) 	out.println("�ź�");
                      	else   										out.println("�¶�");
                     	%>
                    </td>
                    <td width="15%" class='title'>���ݰ�꼭���ϼ��ſ���</td>
                    <td width="35%">&nbsp;
					<%  if(client.getTax_mail_yn().equals("N")) 	out.println("�ź�");
                      	else   										out.println("�¶�");
                     	%>
					</td>
                </tr>					
                <tr>
                    <td class='title'>��꼭���౸��</td>
                    <td width="35%">&nbsp;
                     <%if(client.getPrint_st().equals("1")) 		out.println("���Ǻ�");
                      	else if(client.getPrint_st().equals("2"))   out.println("�ŷ�ó����");
                      	else if(client.getPrint_st().equals("3")) 	out.println("��������");
                     	else if(client.getPrint_st().equals("4"))	out.println("��������");
						else if(client.getPrint_st().equals("5"))	out.println("����/ȭ��/9�ν�/����");
                     	else if(client.getPrint_st().equals("9"))	out.println("Ÿ�ý��۹���");
                     	%>
                    </td>
                    <td class='title'>��꼭�������౸��</td>
                    <td >&nbsp;
					<%  if(client.getPrint_car_st().equals("1"))	out.println("����/ȭ��/9�ν�/����");
                      	else   										out.println("����");
                     	%>
					</td>
                </tr>			
                <tr>                    
                    <td class='title'>���ǿ����꼭���౸��</td>
                    <td >&nbsp;
					<%  if(client.getIm_print_st().equals("Y"))		out.println("�����౸�� �״��");
                      	else   										out.println("������ ��������");
                     	%>
					</td>
					<td class='title'>��꼭 ȸ�� ǥ�� ����</td>
                    <td>&nbsp;
					<%  if (client.getTm_print_yn().equals("N")) 		out.println("��ǥ��");
                      	else if (client.getTm_print_yn().equals("")) 	out.println("ǥ��");
                     	%>                      
					</td>														
                </tr>								
                <tr>			
                    <td width="15%" class='title'>��꼭 ��� ǥ�� ����</td>
                    <td>&nbsp;
					<%  if(client.getBigo_yn().equals("N")) 		out.println("��ǥ��");
						else if(client.getBigo_yn().equals("A"))    out.println("�⺻+�߰����Ժ� ǥ��");
						else if(client.getBigo_yn().equals("B"))    out.println("�߰����Ժи� ǥ��");
                      	else   										out.println("�⺻�� ǥ��");
                     	%>						
					</td>
                    <td class='title'>��꼭ǰ��ǥ�ñ���</td>
                    <td>&nbsp;
					<%  if(client.getEtax_item_st().equals("2")) 	out.println("���ǥ��");
                      	else   										out.println("���ٸ�ǥ��");
                     	%>						
					</td>
                </tr>
                <tr>
                    <td class='title'>��꼭��� �߰�����</td>
                    <td colspan='3'>&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 
					������ : <%=client.getBigo_value1()%>
					&nbsp;&nbsp;
					<img src=/acar/images/center/arrow.gif align=absmiddle>
					������ : NO.<%=client.getBigo_value2()%>
					&nbsp;(�������� ���ڸ� �����մϴ�. ��꼭 ����� �̰��� 1�� �����Ͽ� ��� ǥ���մϴ�.)
					</td>	                    							
                </tr>					
                <tr>
                    <td class='title'>��꼭 û������ ����</td>
                    <td >&nbsp;
					<%  if(client.getPubform().equals("R")) 		out.println("����");
                      	else   										out.println("û��");
                     	%>
					</td>
                    <td class='title'>��ü���ڼ��ſ���</td>
                    <td >&nbsp;
					<%  if(client.getDly_sms().equals("N")) 		out.println("�ź�");
                      	else   										out.println("�¶�");
                     	%>
					</td>
                </tr>						
                <tr>
                    <td class='title'>��å�� û�� ����</td>
                    <td>&nbsp;
					<%  if (client.getEtc_cms().equals("N")) 		out.println("�ź�");
                      	else if (client.getEtc_cms().equals("Y")) 	out.println("�¶�");
                      	else  										out.println("  ");
                     	%>
                      &nbsp;&nbsp;* CMS �ŷ����� ����.	
					</td>
					<td class='title'>�������·� û�� ����</td>
                    <td>&nbsp;
					<%  if (client.getFine_yn().equals("N")) 		out.println("�ź�");
                      	else if (client.getFine_yn().equals("Y")) 	out.println("�¶�");
                      	else  										out.println("  ");
                     	%>
                      &nbsp;&nbsp; 
					</td>
                </tr>				
                       <tr>
                    <td class='title'>��ü���� CMS û�� ����</td>
                    <td >&nbsp;
					<%  if (client.getDly_yn().equals("N")) 		out.println("�ź�");
                      	else if (client.getDly_yn().equals("Y")) 	out.println("�¶�");
                      	else  										out.println("  ");
                     	%>
                      &nbsp;&nbsp;* CMS �ŷ����� ����.	
					</td>
                    <td class='title'>CMS��û���ڼ��ſ���</td>
                    <td >&nbsp;
					<%  if (client.getCms_sms().equals("N")) 		out.println("�ź�");
                      	else if (client.getCms_sms().equals("Y")) 	out.println("�¶�");
                      	else  										out.println("  ");
                     	%>                      
					</td>		
                </tr>					                
                <tr>
                    <td class='title'>�׿����ڵ�</td>
                    <td>&nbsp;<%if(!client.getVen_code().equals("")){%><%=client.getVen_code()%><%}%></td>
                    <td class='title'>�������뵵</td>
                    <td>&nbsp;<%=client.getCar_use()%></td>
                </tr>						
                <tr>
                    <td class='title'> Ư�̻��� </td>
                    <td colspan='3'>&nbsp;
        		        <table border="0" cellspacing="1" cellpadding="4" width=650 height='40'>
                            <tr>
                                <td><%=Util.htmlBR(client.getEtc())%> </td>
                            </tr>
                        </table>
        		    </td>
                </tr>
            </table>
	    </td>
    </tr>
	<tr>
	    <td>&nbsp;</td>
    </tr>    

</table>   




</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
<script language='javascript'>
<!--
	var fm = document.form1;
	<%	if(from_page.equals("")){%>
	//�ٷΰ���
	/*
	var s_fm = parent.parent.top_menu.document.form1;
	s_fm.m_id.value = fm.m_id.value;
	s_fm.l_cd.value = fm.l_cd.value;	
	s_fm.c_id.value = fm.c_id.value;
	s_fm.auth_rw.value = fm.auth_rw.value;
	s_fm.user_id.value = fm.user_id.value;
	s_fm.br_id.value = fm.br_id.value;		
	s_fm.client_id.value = fm.client_id.value;
	s_fm.accid_id.value = "";
	s_fm.serv_id.value = "";
	s_fm.seq_no.value = "";
	*/
	<%}%>
//-->
</script>  
</body>
</html>
