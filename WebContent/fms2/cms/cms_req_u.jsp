<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.cms.*, acar.client.*, acar.cont.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cms.CmsDatabase"/>
<jsp:useBean id="bean" class="acar.cms.CmsCngBean" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?acar_br:request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String req_dt =  request.getParameter("req_dt")==null?"":request.getParameter("req_dt");
	
	int sh_height 	= request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
//	out.println(AddUtil.getDate(4));
	
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
		
	bean = ac_db.getCmsCng(rent_mng_id, rent_l_cd, req_dt);
	
	String est_dt = bean.getEst_dt() ;
	//���⺻����
	ContBaseBean base 	= a_db.getCont(rent_mng_id, rent_l_cd);
	
	//������
	ClientBean client 	= al_db.getClient(base.getClient_id());
	//�����⺻����
	ContCarBean car 	= a_db.getContCar(rent_mng_id, rent_l_cd);
	//�����������
	Hashtable car_fee 	= a_db.getCarRegFee(rent_mng_id, rent_l_cd);
	
	//�����縮��Ʈ
	CodeBean[] banks = c_db.getCodeAllCms("0003");
	int bank_size = banks.length;
	
	
	//	��ݿ����� -������ ������ �����ȵǰ� ���� ��û�� ������ ������ ��찡 ����. 
	String fee_dt = ac_db.getCmsFeeEst_dt(rent_mng_id, rent_l_cd); 
		
	if ( est_dt.equals("29991231")) {
		if ( !fee_dt.equals("29991231") )   est_dt = fee_dt;		
	}
	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+					
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+
					"&mode="+mode+"&from_page="+from_page;
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

	var popObj = null;
		
	function save()
	{
		var fm = document.form1;

		//��ȯ���� �Ұ� 
		
		if(fm.cms_bank.value == '')				{ alert('�ŷ������� �����Ͻʽÿ�'); 		fm.cms_bank.focus(); 		return;	}
		if (fm.cms_bank.value == "��ȯ����")		{ alert('������ �� �����ϴ�. KEB�ϳ������� �����ϼ���!!!'); fm.cms_bank.focus(); 		return;	}
				
		if(fm.cms_acc_no.value == '')				{ alert('���¹�ȣ�� �Է��Ͻʽÿ�'); 		fm.cms_acc_no.focus(); 		return;	}
				
				
		if(confirm('���� �Ͻðڽ��ϱ�?')){		
		
			fm.cmd.value = "u";
			fm.action = "cms_req_u_a.jsp";	
			fm.target='i_no';
			fm.submit();
		}
	}
	
	function get_length(f) {
		var max_len = f.length;
		var len = 0;
		for(k=0;k<max_len;k++) {
			t = f.charAt(k);
			if (escape(t).length > 4)
				len += 2;
			else
				len++;
		}
		return len;
	}
	
	//��ûó��
	function ed_time_in()
	{
		var fm = document.form1;	
		
		
		if(fm.cms_bank.value == '')				{ alert('�ŷ������� �����Ͻʽÿ�'); 		fm.cms_bank.focus(); 		return;	}
		if (fm.cms_bank.value == "��ȯ����")		{ alert('������ �� �����ϴ�. KEB�ϳ������� �����ϼ���!!!'); fm.cms_bank.focus(); 		return;	}
				
		if(fm.cms_acc_no.value == '')				{ alert('���¹�ȣ�� �Է��Ͻʽÿ�'); 		fm.cms_acc_no.focus(); 		return;	}
					
		if(confirm('ó���Ϸ� �Ͻðڽ��ϱ�?')){				
			fm.action='cms_req_end_a.jsp';		
			fm.target='i_no';
			//fm.target='_blank';
			fm.submit();
		}
	}	


	//����
	function del()
	{
		var fm = document.form1;
		if(confirm('���� �Ͻðڽ��ϱ�?')){		
			fm.action='cms_req_d_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}
	}	
	
		
//-->
</script>
</head>

<body>
<form action='' name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>  
  <input type='hidden' name='s_kd' 		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>   
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
  <input type='hidden' name='from_page' value='<%=from_page%>'>
   <input type='hidden' name='rent_mng_id' 		value='<%=rent_mng_id%>'>
   <input type='hidden' name='rent_l_cd' 		value='<%=rent_l_cd%>'>

  <input type='hidden' name='cmd' 		value=''>
  
	
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> �繫ȸ�� > <span class=style5>CMS �������</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 	
    <tr>
    	<td  colspan=2 align='right'>	
    		<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a>
    	</td>
    </tr>
    
    <tr><td class=line2  colspan=2></td></tr>
      <tr> 
        <td class='line' colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width=10%>����ȣ</td>
                    <td width=14%>&nbsp;<%=rent_l_cd%>&nbsp;&nbsp;                    
                    </td>
                    <td class='title' width=10%>��ȣ</td>
                    <td width=18%>&nbsp;<%=client.getFirm_nm()%></td>
                </tr>  
                 <tr>     
                    <td class='title' width=10%>����ڹ�ȣ</td>
                    <td width=14%>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
                    <td class='title' width=10%>�ֹ�/���ι�ȣ</td>
                    <td width=18%>&nbsp;<%=client.getSsn1()%>-<%if(client.getSsn2().length() > 1){%><%=client.getSsn2().substring(0,1)%><%}%>******             
                   </td>
                </tr>          
                <tr>     
                    <td class='title' width=10%>�����</td>
                    <td width=14%>&nbsp;<%=client.getClient_nm()%></td>
                    <td class='title' width=10%>������ȣ</td>
                    <td width=18%>&nbsp;<%=car_fee.get("CAR_NO")%></td>
                </tr>                         
            </table>
        </td>
    </tr>
    <tr>
	  <td align="right">&nbsp;</td>
	</tr>
    <tr>
	  <td colspan=2><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڵ���ü ������ ����</span></td>
	</tr>	
	<tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line' colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width=10%>�ŷ�����</td>
                    <td width=14%>&nbsp;<%=Util.subData(bean.getOld_cms_bank(),6)%></td>
                    <td class='title' width=10%>���¹�ȣ</td>
                    <td width=18%>&nbsp;<%=bean.getOld_cms_acc_no()%>
                     <input type='hidden' name='old_cms_bank' value='<%=bean.getOld_cms_bank()%>' >
                      <input type='hidden' name='old_cms_acc_no' value='<%=bean.getOld_cms_acc_no()%>' >
                    
                    </td>
                </tr>    
                                        
            </table>
        </td>
    </tr>
	<tr>
	  <td align="right">&nbsp;</td>
	</tr>
	<tr> 
        <td colspan=2><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڵ���ü ���泻��</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr> 
    <tr> 
        <td class='line' colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>                 
                    <td class='title'>��û��</td>
                    <td class='title'>��û��</td>
                </tr>
                <tr> 
                    <td align="center"> 
                      <input type='text' name='req_dt' size='20' class='text' value="<%=AddUtil.ChangeDate2(req_dt)%>"  readonly >
                      </td>
                    <td align="center"><%=c_db.getNameById(bean.getReq_id(),"USER")%></td>
                </tr>                
                <tr> 
                    <td class='title'>�ŷ�����</td>
                    <td class='title'>���¹�ȣ</td>                 
                </tr>
                <tr> 
                    <td align='center'> 
                      <select name='cms_bank'>
                        <option value=''>����</option>
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i]; %>                      
                        <option value='<%= bank.getNm()%>' <%if(bean.getCms_bank().equals(bank.getNm())){%> selected <%}%>><%=bank.getNm()%></option>                       
                        <%		}
        					}%>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' name='cms_acc_no' size='20' class='text'  value='<%=bean.getCms_acc_no()%>' >
                    </td>                
                </tr>
    				<tr>                 
                    <td class='title'>������</td>
                    <td class='title'>������ �������/����ڹ�ȣ</td>
                </tr>
                <tr> 
                    <td align="center"> 
                      <input type='text' name='cms_dep_nm' size='20' class='text' value="<%=bean.getCms_dep_nm()%>" style='IME-MODE: active'>
                      </td>
                    <td align="center"> 
                      <input type='text' name='cms_dep_ssn' size='15' class='text' value="<%=AddUtil.ChangeSsn(bean.getCms_dep_ssn())%>">
                    </td>
                </tr>  
                <tr>                 
                    <td class='title'>����纻</td>
                    <td class='title'>CMS���Ǽ�</td>
                </tr> 
                <tr>
                     
                   <td align="center"> &nbsp;
                    <%
                	String content_code  = "LC_SCAN";
                	                     
                	Vector attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "9", 0);
                	int attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j <1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                    %>                
                    
                                <a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a>
        
                    <%		}
                	}
                    %>         
                    </td>                  
                   <td align="center"> &nbsp;
                    <%
                	content_code  = "LC_SCAN";
              
                   	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "38", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
			         	for (int j = 0 ; j < 1 ; j++){
 				        	Hashtable ht = (Hashtable)attach_vt.elementAt(j);      
 				        	    
                    %>                
                    
                                <a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a>
        
                    <%		}
                	}
                    %>         
                    </td>  
                  </tr>
                  <tr>
					    	<td class='title'><%if(bean.getApp_dt().equals("")){%>ó���Ϸ� ���<%}else{%>ó���Ϸ���<%}%></td>
					    	<td>&nbsp;
					    		<%	if(bean.getApp_dt().equals("")){%>
								<%		if(!mode.equals("view")){%>
								<%	if( nm_db.getWorkAuthUser("������",user_id) ||  nm_db.getWorkAuthUser("CMS����",user_id) ||  nm_db.getWorkAuthUser("��ݴ��",user_id)  ){%>	
								<a href='javascript:ed_time_in()' border='0' class=copy><img src="/acar/images/center/button_in_reg.gif"  align="absmiddle" border="0"></a>					
								
								<%			}%>
								<%		}%>						
								<%	}else{%>		
								<%=AddUtil.ChangeDate3(bean.getApp_dt())%>&nbsp;<font color=red>[ó���Ϸ�]</font>
								<%	}%>
					    	</td>
					    </tr>   
      	 </table>
        </td>
    </tr>

    <tr>
        <td class=h></td>
    </tr> 	
    <tr>
    	<td  colspan=2 align='right'>		   
    		<%	if( nm_db.getWorkAuthUser("������",user_id) ||  nm_db.getWorkAuthUser("CMS����",user_id) ||  nm_db.getWorkAuthUser("��ݴ��",user_id) ||  nm_db.getWorkAuthUser("�����ⳳ",user_id)  ){%>			
			<%		if(bean.getApp_st().equals("N")){%>
			<a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a>
			&nbsp;&nbsp;&nbsp;
			<a href='javascript:del()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_delete.gif" align="absmiddle" border="0"></a>
			<%		}%>
			<%}%>		
    	</td>
    </tr>    
    
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;�� [�뿩�� �Աݿ�����(����)] : <font color=red><%= AddUtil.ChangeDate3(est_dt)%></font></td>
	</tr>	
	
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;�� [ó���Ϸ�] �Ǿ�� CMS�������� �ش��û����Ÿ�� ��ȸ�˴ϴ�.</td>
	</tr>	
		
</form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
<script language="JavaScript">
<!--	
	
//-->
</script>		
</body>
</html>
			    