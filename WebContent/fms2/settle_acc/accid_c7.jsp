<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.accid.*, acar.car_service.*, tax.*, acar.user_mng.*, acar.cont.*,acar.ext.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="s_bean2" class="acar.car_service.ServiceBean" scope="page"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="si_bean" class="acar.car_service.ServItem2Bean" scope="page"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//��������ȣ
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//����ȣ
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//��������ȣ
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");//��������ȣ
	String mode = request.getParameter("mode")==null?"7":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
			
	AccidDatabase as_db = AccidDatabase.getInstance();
	AddCarServDatabase a_csd = AddCarServDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	
	CarServDatabase csd = CarServDatabase.getInstance();
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "02", "04");
	
	int acc_size = 0;
	
	//�����ȸ
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	//�����ȸ
	AccidentBean a_bean = as_db.getAccidentBean(c_id, accid_id);
	
		//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP"); 
	int user_size = users.size();
	
	int  max_nn = 0;
	
	//����/����(��å��)
	ServiceBean s_r [] = as_db.getServiceList(c_id, accid_id);

	if(serv_id.equals("") && s_r.length>0){
		for(int i=0; i<1; i++){
			s_bean2 = s_r[i];
			serv_id = s_bean2.getServ_id();
			
			//��û������ �ִٸ�
			if ( serv_id.substring(0,2).equals("NN")) {
			  max_nn = AddUtil.parseInt(serv_id.substring(2,6));
			  			
			}
					
		}
	}
	
	
	// ����������
	acc_size = s_r.length;
	if (acc_size < max_nn ) {
		acc_size = max_nn;
	}
	
	if (serv_id.equals("")) serv_id = "NN0001";

	//����/����(��å��)
	ServiceBean s_bean = a_csd.getService(c_id, accid_id, serv_id);	
	
	String bus_id2 = "";
	
	if ( !s_bean.getBus_id2().equals("")){
	 	bus_id2 = s_bean.getBus_id2();
	} else {
	    if ( !a_bean.getBus_id2().equals("") ) {  //�������� �����
	  	    bus_id2 = a_bean.getBus_id2();
	    } else {
			bus_id2 = (String)cont.get("BUS_ID2");
		}	
	}
	
	int s_cnt = 0;
	s_cnt = a_csd.getService(c_id, accid_id, serv_id, "1");	
   
	
	//û�������� ��ȸ
	TaxItemListBean ti = IssueDb.getTaxItemListServM(c_id, serv_id, s_bean.getCust_amt());
	
	
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
	
	Vector grts = ae_db.getExtScd(m_id, l_cd, "3");
	int grt_size = grts.size();
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//�˾������� ���� - �������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	
	
		
//-->
</script>
</head>
<body>
<form action="" name="form1">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>

    <input type='hidden' name='m_id' value='<%=m_id%>'>
    <input type='hidden' name='l_cd' value='<%=l_cd%>'>
    <input type='hidden' name='c_id' value='<%=c_id%>'>
    <input type='hidden' name='accid_id' value='<%=accid_id%>'>
    <input type='hidden' name='mode' value='<%=mode%>'>
    <input type='hidden' name='serv_id' value='<%=serv_id%>'>  
    <input type='hidden' name='cmd' value='<%=cmd%>'>
    <input type='hidden' name='go_url' value='<%=go_url%>'>  		
    <input type='hidden' name='l_cd2' value='<%=s_bean.getRent_l_cd()%>'> 
	<input type='hidden' name="item_id" value="<%=ti.getItem_id()%>"> 	
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����</span></td>
    </tr>  
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>������ȣ</td>
                    <td width=15%>&nbsp; 
                      <%=c_id%>-<%=accid_id%>
                    </td>
                    <td class=title width=10%>�����</td>
                    <td width=15%>&nbsp;
                      <%if(a_bean.getAccid_st().equals("1")){%>������<%}%>
                      <%if(a_bean.getAccid_st().equals("2")){%>������<%}%>
                      <%if(a_bean.getAccid_st().equals("3")){%>�ֹ�<%}%>
                      <%if(a_bean.getAccid_st().equals("5")){%>�������<%}%>
                      <%if(a_bean.getAccid_st().equals("4")){%>��������<%}%>
                      <%if(a_bean.getAccid_st().equals("6")){%>����<%}%>
					  <%if(a_bean.getAccid_st().equals("7")){%>�縮������<%}%>
                    </td>
					<td class=title width=10%>�߻��Ͻ�</td>
                    <td width=15%>&nbsp; 
                      &nbsp;<%=AddUtil.ChangeDate2(a_bean.getAccid_dt())%>
                    </td>
					<td class=title width=10%>�����Ͻ�</td>
                    <td width=15%>&nbsp; 
                      &nbsp;<%=AddUtil.ChangeDate2(a_bean.getReg_dt())%>
                    </td>										
                </tr>
                <tr>
                  <td class=title>������</td>
                  <td colspan="7">&nbsp;
				    <%if(a_bean.getAccid_type_sub().equals("1")){%>[���Ϸ�]<%}%>
                    <%if(a_bean.getAccid_type_sub().equals("2")){%>[������]<%}%>
                    <%if(a_bean.getAccid_type_sub().equals("3")){%>[ö��ǳθ�]<%}%>
                    <%if(a_bean.getAccid_type_sub().equals("4")){%>[Ŀ���]<%}%>
                    <%if(a_bean.getAccid_type_sub().equals("5")){%>[����]<%}%>
                    <%if(a_bean.getAccid_type_sub().equals("6")){%>[������]<%}%>
                    <%if(a_bean.getAccid_type_sub().equals("7")){%>[����]<%}%>
                    <%if(a_bean.getAccid_type_sub().equals("8")){%>[��Ÿ]<%}%>
					<%if(!a_bean.getAccid_type_sub().equals("")){%>&nbsp;<%}%>
                    <%=a_bean.getAccid_addr()%></td>
                </tr>
                <tr>
                  <td class=title>������</td>
                  <td colspan="7">&nbsp;
				    <%=a_bean.getAccid_cont()%>
					<%if(!a_bean.getAccid_cont2().equals("") && !a_bean.getAccid_cont().equals(a_bean.getAccid_cont2())){%>
					<br>&nbsp;
					<%=a_bean.getAccid_cont2()%>
					<%}%>
				  </td>
                </tr>
                <tr>
                  <td class=title>Ư�̻���</td>
                  <td colspan="7">&nbsp;
				    <%=a_bean.getSub_etc()%>
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
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width="5%">����</td>
                    <td class=title width="10%">��������</td>
                    <td class=title width="20%">�����ü��</td>
                    <td class=title width="12%">����ó</td>
                    <td class=title width="12%">�ѽ���ȣ</td>
                    <td class=title width="15%">����ݾ�</td>
                    <td class=title width="26%">���񳻿�</td>
                </tr>
              	<%	
					for(int i=0; i<s_r.length; i++){
        				s_bean = s_r[i];
						s_cnt++;
						
						ServItem2Bean si_r [] = csd.getServItem2All(s_bean.getCar_mng_id(), s_bean.getServ_id());
						String f_item = "";
						String a_item = "";
						for(int j=0; j<si_r.length; j++){
 							si_bean = si_r[j];
							if(j==0) f_item = si_bean.getItem();
							if(j==si_r.length-1){
        				    	a_item += si_bean.getItem();
        				    }else{
        				    	a_item += si_bean.getItem()+",";
        				    }
        				}%>
                <tr> 
                    <td <%if(serv_id.equals(s_bean.getServ_id())){%>class=star<%}%> align="center"><%=i+1%></td>
                    <td <%if(serv_id.equals(s_bean.getServ_id())){%>class=star<%}%> align="center"><%=AddUtil.ChangeDate2(s_bean.getServ_dt())%></td>
                    <td <%if(serv_id.equals(s_bean.getServ_id())){%>class=star<%}%> align="center"><%=s_bean.getOff_nm()%></td>
                    <td <%if(serv_id.equals(s_bean.getServ_id())){%>class=star<%}%> align="center"><%=s_bean.getOff_tel()%></td>
                    <td <%if(serv_id.equals(s_bean.getServ_id())){%>class=star<%}%> align="center"><%=s_bean.getOff_fax()%></td>
                    <td <%if(serv_id.equals(s_bean.getServ_id())){%>class=star<%}%> align="right">
		                 <% if ( s_bean.getR_j_amt() > 0) { %>  
        		         <%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf((s_bean.getR_labor()+s_bean.getR_j_amt())* 1.1)))%>��
		                 <% } else { %>   
        		         <%=AddUtil.parseDecimal(s_bean.getTot_amt())%>��
                		 <% } %>
	                </td>
                    <td <%if(serv_id.equals(s_bean.getServ_id())){%>class=star<%}%> >
					<%	if(!a_item.equals("")){%>
					<span title="<%=a_item%>">&nbsp;<%=f_item%><% if(si_r.length>1){ %>�� <font color="red"><%=si_r.length-1%></font>�� <% } %></span>								
					<%	}else{%>
					<span title="<%=s_bean.getRep_cont()%>">&nbsp;<%=Util.subData(s_bean.getRep_cont(),15)%></span>
					<%	}%> 
					<!-- �������ķ���ο��� ��¥�и��� ������ �� ���� ��û������ ���� ���� -->  
                    <% if ( !s_bean.getRep_cont().equals("��å�� ��û����") ) { %>
	        			<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	        			<a href="javascript:MM_openBrWindow('/acar/cus_reg/serv_reg.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&car_mng_id=<%=c_id%>&accid_id=<%=accid_id%>&serv_id=<%=s_bean.getServ_id()%>&cmd=4','popwin_loop','scrollbars=yes,status=no,resizable=no,width=850,height=700,top=20,left=20')"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
	        			<%}%>
	        		<% } %>
					</td>
                </tr>
              	<%	}%>	  
            </table>
        </td>
    </tr>
    <tr>
		<td class=h></td>
	</tr> 	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��å��</span></td>
    </tr>  
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
           	  		
                <tr> 
                    <td width="10%" class=title>��������</td>
                    <td width="15%" >&nbsp;<%=AddUtil.ChangeDate2(s_bean.getServ_dt())%></td>
                    <td width="10%"  class=title>�����ü��</td>
                    <td width="15%" >&nbsp;<%=s_bean.getOff_nm()%></td>
                    <td width="10%" class=title>û������</td>
                    <td width="15%" >&nbsp;<select name="paid_st" disabled>
                    	<option value="" <%if(s_bean.getPaid_st().equals(""))%>selected<%%>>-����-</option>
                        <option value="1" <%if(s_bean.getPaid_st().equals("1"))%>selected<%%>>��</option>
                        <option value="2" <%if(s_bean.getPaid_st().equals("2"))%>selected<%%>>��Ÿ</option>
                        </select> 
                    </td>
                    <td width="10%" class=title >���谡��<br>��å��</td>
                    <td width="15%" >&nbsp; <%=AddUtil.parseDecimal(String.valueOf(cont.get("CAR_JA")))%>��<br>&nbsp;&nbsp;&nbsp;&nbsp;(���ް�)</td>
           		</tr>      
                <tr>      
                    <td class=title>û������</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(s_bean.getCust_req_dt())%></td>  
                    <td class=title>û�����ް���</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(s_bean.getCust_s_amt())%></td>
                    <td class=title>û���ΰ�����</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(s_bean.getCust_v_amt())%></td>
                    <td class=title>û���ݾ�</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(s_bean.getCust_amt())%></td>
               </tr>
                <tr>
                  <td class=title>�������</td>
                  <td>&nbsp;
                    <select name='bus_id2' disabled>
                      <option value="">������</option>
                      <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                      <option value='<%=user.get("USER_ID")%>' <%if(bus_id2.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                      <%		}
        					}		%>
                    </select></td>
                  <td class=title>�Աݿ�����</td>
                  <td>&nbsp;<%=AddUtil.ChangeDate2(s_bean.getCust_plan_dt())%></td>
                  <td class=title>�Ա���</td>
                  <td colspan="3">&nbsp;<%=AddUtil.ChangeDate2(s_bean.getCust_pay_dt())%></td>
                </tr>
               <tr>                    
                    <td class=title>���Աݾ�</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(s_bean.getExt_amt())%>��</td>
                    <td class=title>���Աݳ���</td>
                    <td colspan=5 >&nbsp;<%=s_bean.getExt_cau()%></td>                                      
                </tr>
                <tr>
                    <td class=title>���������<br>���ް���</td>
                    <td >&nbsp;<%=AddUtil.parseDecimal(s_bean.getCls_s_amt())%></td>  
                    <td class=title>���������<br>�ΰ�����</td>
                    <td >&nbsp;<%=AddUtil.parseDecimal(s_bean.getCls_v_amt())%>��</td>  
                    <td class=title>���������<br>�ݾ�</td>
                    <td colspan="3" >&nbsp;<%=AddUtil.parseDecimal(s_bean.getCls_amt())%>��                    </td> 
                </tr>
                <tr> 
                    <td class=title>��������</td>
                    <td>&nbsp; <input type='checkbox' name='no_dft_yn' value="Y" <%if(s_bean.getNo_dft_yn().equals("Y"))%> checked<%%>> 
                    </td>
                    <td class=title>��������</td>
                    <td colspan="5">&nbsp;<%=s_bean.getNo_dft_cau()%>
                    </td>                 
                </tr>
            </table>
        </td>
    </tr>
    <tr>
		<td class=h></td>
	</tr> 	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ݽ�����</span></td>
    </tr>  
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=10%  class='title'>ȸ��</td>
                    <td width=15% class='title'>���ް�</td>
                    <td width=15% class='title'>�ΰ���</td>
                    <td width=15% class='title'>�հ�</td>
                    <td width=15% class='title'>�Աݿ�����</td>
                    <td width=15% class='title'>�Ա���</td>
                    <td width=15% class='title'>�Աݾ�</td>
                </tr>
          <%		for(int i = 0 ; i < grt_size ; i++){
			ExtScdBean grt = (ExtScdBean)grts.elementAt(i);
			if(!grt.getExt_pay_dt().equals("")){%>
                <tr> 
                    <td align='center'><%=grt.getExt_tm()%>ȸ<%if(!grt.getExt_tm().equals("1")){%>(�ܾ�)<%}%></td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_s_amt())%>��&nbsp;</td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_v_amt())%>��&nbsp;</td>
                    <td align='right'><input type='text' name='t_grt_amt' value='<%=Util.parseDecimal(grt.getExt_s_amt()+grt.getExt_v_amt())%>' class='whitenum' readonly size="10">
        			��&nbsp;</td>
                    <td align='center'> <input type='text' name='t_grt_est_dt' size='11' value='<%=grt.getExt_est_dt()%>' class='whitetext' maxlength='10' onBlur='javascript:this.value = ChangeDate(this.value);'> 
                    </td>
                    <td align='center'> <input type='text' name='t_grt_pay_dt' size='11' value='<%=grt.getExt_pay_dt()%>' class='whitetext' maxlength='10' onBlur='javascript:this.value=ChangeDate(this.value);'> 
                    </td>
                    <td align='right'> <input type='text' name='t_grt_pay_amt' size='10' class='whitenum' maxlength='10' value='<%=Util.parseDecimal(grt.getExt_pay_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��&nbsp;</td>
                </tr>
          <%			}else{%>
                <tr> 
                    <td align='center'><%=grt.getExt_tm()%>ȸ<%if(!grt.getExt_tm().equals("1")){%>(�ܾ�)<%}%></td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_s_amt())%>��&nbsp;</td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_v_amt())%>��&nbsp;</td>
                    <td align='right'> <input type='text' name='t_grt_amt' value='<%=Util.parseDecimal(grt.getExt_s_amt()+grt.getExt_v_amt())%>' class='whitenum' readonly size="10">
                      ��&nbsp;</td>
                    <td align='center'> <input type='text' name='t_grt_est_dt' size='11' value='<%=grt.getExt_est_dt()%>' class='whitetext' maxlength='10' onBlur='javascript:this.value = ChangeDate(this.value);'> 
                    </td>
                    <td align='center'> <input type='text' name='t_grt_pay_dt' size='11' value='<%=grt.getExt_pay_dt()%>' class='whitetext' maxlength='10' onBlur='javascript:this.value=ChangeDate(this.value);'> 
                    </td>
                    <td align='right'> <input type='text' name='t_grt_pay_amt' size='10' class='whitenum' maxlength='10' value='' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��&nbsp;</td>			
                </tr>
          <%			}
		}%>
            </table>
        </td>
    </tr>	
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
        <td align=right><a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"></a></td>
    </tr>    
</table>
  </form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</iframe>
</body>
</html>
