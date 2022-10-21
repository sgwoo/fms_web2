<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cont.*, acar.cus_pre.*, acar.user_mng.*, acar.condition.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CusPre_Database cp_db = CusPre_Database.getInstance();
	ConditionDatabase cdb = ConditionDatabase.getInstance();
	
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	Hashtable id = c_db.getDamdang_id(user_nm);
	user_id = String.valueOf(id.get("USER_ID"));
	
	//�ű԰�ళ��
	Vector conts1 = cp_db.getContList(br_id, user_id, "1");
	
	//��ุ�Ό��
	Vector conts2 = cp_db.getContList(br_id, user_id, "2");
	
	
	//�α���ID&������ID&����
	String acar_id = ck_acar_id;
%>
<%	%>
<html>
<head>
<title>:: FMS ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	//��������� ����
	function cng_bus(m_id, l_cd){
//		window.open("/acar/car_rent/cng_bus.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>&mode=cus", "CNG_BUS", "left=100, top=10, width=400, height=220, scrollbars=yes, status=yes");
		window.open("/fms2/lc_rent/cng_item.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&cng_item=bus_id2&from_page=/acar/cus_pre/cus_pre_sc_ct.jsp", "CNG_BUS", "left=100, top=10, width=720, height=450, scrollbars=yes, status=yes");
	}
	//���ΰ�ħ
	function CusPreCtRelode(){
		var fm = document.form1;
		fm.action = 'cus_pre_sc_ct.jsp';		
		fm.submit();					
	}	
		//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
	
	function view_memo(m_id, l_cd, c_id, tm_st, accid_id, serv_id, mng_id){
		
		window.open("/acar/condition/rent_memo_frame_s.jsp?tm_st="+tm_st+"&m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&accid_id="+accid_id+"&serv_id="+serv_id+"&mng_id="+mng_id, "INS_MEMO", "left=100, top=100, width=700, height=600");
	}

	//����� ��༭ ���� ����
	function view_cont(m_id, l_cd){
		var fm = document.form1;
	//	fm.rent_mng_id.value = m_id;
	//	fm.rent_l_cd.value = l_cd;
		fm.target ='d_content';
		fm.action = '/fms2/lc_rent/lc_c_frame.jsp?rent_mng_id='+m_id+'&rent_l_cd='+l_cd;
		fm.submit();
	}
	
	//����� ���ǿ��� ���
	function reg_im_cont(m_id, l_cd, car_no){
	//	var fm = document.form1;
	//	var fm2 = document.form2;
		
	//	if(confirm('���ǿ��� ������� �Ѿ�ڽ��ϱ�?')){	

		//	fm2.target ='c_head';
		//	fm2.action = '/fms2/lc_rent/lc_im_renew_h.jsp?s_kd=2&t_wd='+car_no;
		//	fm2.submit();		
		
		//	fm.target ='c_body';
		//	fm.action = '/fms2/lc_rent/lc_im_renew_c.jsp?rent_mng_id='+m_id+'&rent_l_cd='+l_cd;
		//	fm.submit();
		
		window.open("/fms2/lc_rent/lc_im_renew_c.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&mode=pop", "RENEW", "left=10, top=10, width=1050, height=700, scrollbars=yes");
	//	}
	}
	
	
//-->
</script>
</head>

<body><a name="top"></a>
<form name='form2' method='post' action=''>
</form>
<form name='form1' method='post' action=''>
<input type='hidden' name='gubun1' value=''>
<input type='hidden' name='gubun2' value=''>
<input type='hidden' name='gubun3' value=''>
<input type='hidden' name='t_wd' value=''>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td><a name='5'></a></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ű԰�ళ�� (D+30��) : �� <font color="#FF0000"><%= conts1.size() %></font>��</span></td>
    </tr>
    <tr>    
        <td class=line2></td>
    </tr>
    <tr> 
        <td width="100%" class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width=3% class='title'>����</td>
                    <td width=19% class='title'>��ȣ</td>
                    <td width=11% class='title'>������ȣ</td>
                    <td width=13% class='title'>����</td>
                    <td width=11% class='title'>�뿩������</td>
                    <td width=11% class='title'>�뿩����</td>
                    <td width=8% class='title'>�뿩����</td>
                    <td width=8% class='title'>���ʿ���</td>
                    <td width=8% class='title'>�������</td>
                    <td width=8% class='title'>�������</td>
                </tr>
          <%if(conts1.size() > 0){
         		for(int i = 0 ; i < conts1.size() ; i++){
					RentListBean cont = (RentListBean)conts1.elementAt(i); %>
                <tr> 
                    <td align='center'>                   		
                    <%= i+1 %></td>
                    <td align='center'><a href="javascript:view_cont('<%=cont.getRent_mng_id()%>', '<%=cont.getRent_l_cd()%>')" onMouseOver="window.status=''; return true" title='<%=cont.getFirm_nm()%> �������� �̵�'>                   	
                    	<%=AddUtil.subData(cont.getFirm_nm(), 9)%>
                   	  </a></span></td>
                    <td align='center'><span title='<%=cont.getCar_no()%>'><%=cont.getCar_no()%></span></td>
                    <td align='center'><span title='<%=cont.getCar_nm()%>'><%=AddUtil.subData(cont.getCar_nm(), 10)%></span></td>
                    <td align='center'><%=cont.getRent_start_dt()%></td>
                    <td align='center'><% if(cont.getCar_st().equals("1")) out.print("��Ʈ");
        			                      else if(cont.getCar_st().equals("3")) out.print("����"); %> <%=cont.getRent_way()%></td>
                    <td align='center'><%if(!cont.getCon_mon().equals("")){%>
                      <%=cont.getCon_mon()%>����
                      <%}else{%>
                      -
                      <%}%></td>
                    <td align='center'><%=c_db.getNameById(cont.getBus_id(), "USER")%></td>
                    <td align='center'><%=c_db.getNameById(cont.getBus_id2(), "USER")%></td>
                    <td align='center'><% if(cont.getMng_id().equals("")){%>������<%}else{%><%=c_db.getNameById(cont.getMng_id(), "USER")%><%}%></td>
                </tr>
          <% }
		  }else{ %>
                <tr> 
                    <td colspan="10" align='center'>�ش��ϴ� �ű� ������ �����ϴ�.</td>
                </tr>
          <%}%>
             </table>
        </td>
    </tr>
    <tr> 
        <td><a name='6'></a></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ุ�Ό�� (D-30��) : �� <font color="#FF0000"><%= conts2.size() %></font>��</span></td>
    </tr>
    <tr>    
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                   <td width=3% class='title'>����</td>
                    <td width=13% class='title'>��ȣ</td>
                    <td width=10% class='title'>������ȣ</td>
                    <td width=14% class='title'>����</td>
                    <td width=7% class='title'>�뿩������</td>
                    <td width=7% class='title'>�뿩������</td>
                    <td width=8% class='title'>������������</td>					
                    <td width=8% class='title'>�뿩����</td>
                    <td width=6% class='title'>�������</td>
                    <td width=6% class='title'>���ʿ���</td>										
                    <td width=6% class='title'>�������</td>
                    <td width=6% class='title'>�������</td>
                    <td width=6% class='title'>����</td>
                </tr>
          <%if(conts2.size() > 0){
         		for(int i = 0 ; i < conts2.size() ; i++){
					RentListBean cont = (RentListBean)conts2.elementAt(i);
					//���ǿ���
					Hashtable ht = cdb.getFeeImList2(cont.getRent_mng_id(), cont.getRent_l_cd(), "");
					%>
                <tr> 
                    <td align='center'>
                      <a href="javascript:view_memo('<%=cont.getRent_mng_id()%>','<%=cont.getRent_l_cd()%>','','1','','','')" onMouseOver="window.status=''; title='��ุ��޸�'; return true; " ) ><%= i+1%></a>
					</td>
					<!--<td align='center'><%=cont.getRent_l_cd()%></td>-->
                    <td align='center'> 
					  <a href="javascript:view_cont('<%=cont.getRent_mng_id()%>', '<%=cont.getRent_l_cd()%>')" onMouseOver="window.status=''; return true" title='<%=cont.getFirm_nm()%> �������� �̵�'>                   	
                    	<%=AddUtil.subData(cont.getFirm_nm(), 9)%>
                   	  </a>
                    </td>
                    <td align='center'><span title='<%=cont.getCar_no()%>'><%=cont.getCar_no()%></span></td>
                    <td align='center'><span title='<%=cont.getCar_nm()%>'>
                   <% if  (  cont.getScan_file().equals("8") ) { %><font color=red>[��]</font><% } %>&nbsp; <%=AddUtil.subData(cont.getCar_nm(), 10)%></span></td>		
                 
                    <td align='center'><%=cont.getRent_start_dt()%></td>
                    <td align='center'><%=cont.getRent_end_dt()%></td>
					<td align='center'><a href="javascript:reg_im_cont('<%=cont.getRent_mng_id()%>', '<%=cont.getRent_l_cd()%>', '<%=cont.getCar_no()%>')" onMouseOver="window.status=''; return true" title='<%=cont.getFirm_nm()%> ���ǿ��������� �̵�'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FEE_EST_DT")))%></a></td>
                    <td align='center'><% if(cont.getCar_st().equals("1")) out.print("��Ʈ");
        			                      else if(cont.getCar_st().equals("3")) out.print("����"); %> <%=cont.getRent_way()%></td>
                    <td align='center'><%=cont.getEmp_nm()%></td>							
                    <td align='center'><%=c_db.getNameById(cont.getBus_id(), "USER")%></td>								  
                    <td align='center'><%=c_db.getNameById(cont.getBus_id2(), "USER")%></td>
                    <td align='center'><%=c_db.getNameById(cont.getMng_id(), "USER")%></td>
                     <td align='center'>
					 <a href="javascript:view_memo('<%=cont.getRent_mng_id()%>','<%=cont.getRent_l_cd()%>','','1','','','')" onMouseOver="window.status=''; title='��ุ��޸�'; return true; " ) >
					 <% if(cont.getRe_bus_nm().equals("")){%>
					 <img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0>
					 <%}else{%>
					 <%=cont.getRe_bus_nm()%>
					 <%}%>
					 </a>
					 </td>
                </tr>
          <% }
		  }else{ %>
                <tr> 
                    <td colspan="13" align='center'>�ش��ϴ� ���� ������ �����ϴ�.</td>
                </tr>
          <% } %>
            </table>
        </td>
    </tr>	    
	
</table>
</form>
</body>
</html>

