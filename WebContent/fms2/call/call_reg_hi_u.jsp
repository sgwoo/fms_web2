<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*, acar.cont.*,  acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="p_db" scope="page" class="acar.call.PollDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//�����ȸ ������
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	//�޴�����
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");	//�����ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");		//�Ҽӻ�ID
	
	//�˻�����
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank 	= request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String cont_st 	= request.getParameter("cont_st")==null?"":request.getParameter("cont_st");
	String b_lst 	= request.getParameter("b_lst")==null?"":request.getParameter("b_lst");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");		//rent_mng_id
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");		//rent_l_cd
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");		//car_mng_id
	String s_id 	= request.getParameter("s_id")==null?"":request.getParameter("s_id");		//serv_id
	String use_yn 	= request.getParameter("use_yn")==null?"":request.getParameter("use_yn");	//������
	String gubun1 	= request.getParameter("gubun1")==null?"20":request.getParameter("gubun1");
	
	String type 	= request.getParameter("type")==null?"1":request.getParameter("type");
	
	String dt = request.getParameter("dt")==null?"1":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");	
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "16", "01", "01");
	
	//�������
	ContBaseBean base = a_db.getContBaseHi(m_id, l_cd);
	if(c_id.equals(""))	c_id = base.getCar_mng_id();
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(m_id, l_cd);
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	

	//cont call  reg_id
	String reg_id 	= "";
	reg_id = p_db.getCallServiceReg_id(m_id, l_cd,c_id,s_id);	
	
	if ( reg_id.equals("")) {
		reg_id = user_id;
	}

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

	//����ϱ�
	function save()
	{		
		var fm = document.form1;		
		var t_fm = parent.c_foot.document.form1;
				
	}


	//�����ϱ�
	function update()
	{
		var fm = document.form1;	
		save();			
		parent.c_foot.save();
		
	}	
	
	
	//��Ϻ���
	function list(b_lst)
	{
		var fm = document.form1;
		var auth = fm.auth_rw.value;
		var s_kd = fm.s_kd.value;
		var brch_id = fm.brch_id.value;
		var s_bank = fm.s_bank.value;
		var t_wd = fm.t_wd.value;		
		var cont_st = fm.cont_st.value;		
		var type1 = fm.type.value;		
		
		if ( type1 == '1' ) {
			parent.location='/fms2/call/car_service_s_frame.jsp?dt='+fm.dt.value+'&gubun2='+fm.gubun2.value+'&ref_dt1='+fm.ref_dt1.value+'&ref_dt2='+fm.ref_dt2.value+'&auth_rw='+auth+'&s_kd='+s_kd+'&brch_id='+brch_id+'&s_bank='+s_bank+'&t_wd='+t_wd+'&cont_st='+cont_st;
		} else { 
			parent.location='/fms2/call/call_car_service_frame.jsp?auth_rw='+auth+'&s_kd='+s_kd+'&brch_id='+brch_id+'&s_bank='+s_bank+'&t_wd='+t_wd+'&cont_st='+cont_st;
		}
	}		

	
//-->
</script>
<style type=text/css>

<!--
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
</head>
<body leftmargin="15">
<form action='call_service_reg_hi_u_a.jsp' name="form1" method='post'>
<input type='hidden' name='h_pay_tm' value=''>
<input type='hidden' name='h_pay_start_dt' value=''>
<input type='hidden' name='h_pay_end_dt' value=''>
<input type='hidden' name='h_brch' value='<%= base.getBrch_id()%>'>
<input type='hidden' name='use_yn' value='<%=base.getUse_yn()%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='s_id' value='<%=s_id%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_bank' value='<%=s_bank%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='cont_st' value='<%=cont_st%>'>
<input type='hidden' name='b_lst' value='<%=b_lst%>'> 
<input type='hidden' name='type' value='<%=type%>'> 
<input type='hidden' name="s_dept_id" value=''>
<input type='hidden' name='dt' value="<%=dt%>">
<input type='hidden' name='gubun2' value="<%=gubun2%>">
<input type='hidden' name='ref_dt1' value="<%=ref_dt1%>">
<input type='hidden' name='ref_dt2' value="<%=ref_dt2%>"> 
 
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�ݼ��� > <span class=style5>�ݰ���</span></span></td>
                    <td class=bar align=right>
                    <%if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                      <% if ( reg_id.equals(user_id)  ||  nm_db.getWorkAuthUser("������",user_id)   ) {%>
                      <a href='javascript:update()' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_modify.gif" border=0></a>
                      <%}%>
        		  <%}%>
        		  	
                      <a href='javascript:list("<%=b_lst%>")' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif border= align=absmiddle></a> 
                    </td>
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
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width="110">����ȣ</td>
                    <td width="160" class=b>&nbsp; 
                      <input type="text" name="t_con_cd" value="<%=base.getRent_l_cd()%>" size="15" class='whitetext' readonly >
                    </td>
                    <td class=title width="100">�������</td>
                    <td width="160" class=b>&nbsp; 
                      <input type="text" name="t_rent_dt" value="<%=base.getRent_dt()%>" size="12" maxlength='12' class=whitetext onBlur='javascript: this.value = ChangeDate(this.value)'>
                    </td>
                    <td class=title width="100">��౸��</td>
                    <td  colspan="3" class=b>&nbsp; 
                      <select name='s_rent_st' onChange='javascript:change_sub_menu()' disabled >
                        <option value='1' <% if(base.getRent_st().equals("1")){%> selected <%}%>>�ű�</option>
                        <option value='3' <% if(base.getRent_st().equals("3")){%> selected <%}%>>����</option>
                        <option value='4' <% if(base.getRent_st().equals("4")){%> selected <%}%>>����</option>
                        <option value='5' <% if(base.getRent_st().equals("5")){%> selected <%}%>>����(6�����̸�)</option>
                        <option value='2' <% if(base.getRent_st().equals("2")){%> selected <%}%>>����(6�����̻�)</option>
                        <option value='6' <% if(base.getRent_st().equals("6")){%> selected <%}%>>�縮��(6�����̻�)</option>
                        <option value='7' <% if(base.getRent_st().equals("7")){%> selected <%}%>>�縮��(6�����̸�)</option>				
                      </select>
                    </td>
                    
                </tr>
                <tr>
                    <td align="center" class=title>�뿩����</td>
                    <td width="160" class=b>&nbsp;
                      <select name="s_car_st" onChange='javascript:set_con_cd()' disabled >
                        <%if(base.getCar_st().equals("1") || base.getCar_st().equals("3")){%>
                        <option value="1" <%if(base.getCar_st().equals("1")){%>selected<%}%>>��Ʈ</option>
                        <option value="3" <%if(base.getCar_st().equals("3")){%>selected<%}%>>����</option>
                        <%}else if(base.getCar_st().equals("2")){%>
                        <option value="2" <%if(base.getCar_st().equals("2")){%>selected<%}%>>����</option>
                        <%}%>
                    </select></td>
                    <td width="100" align="center" class=title>�뿩���</td>
                    <td width="160" class=b>&nbsp;
                      <%if(nm_db.getWorkAuthUser("�뿩��ĺ���",user_id)){%>
                      <select name="s_rent_way" disabled >
                        <option value=''  <%if(base.getRent_way().equals("")){%>selected<%}%>>����</option>
                        <option value='1' <%if(base.getRent_way().equals("1")){%>selected<%}%>>�Ϲݽ�</option>
                        <option value='2' <%if(base.getRent_way().equals("2")){%>selected<%}%>>�����</option>
                        <option value='3' <%if(base.getRent_way().equals("3")){%>selected<%}%>>�⺻��</option>
                      </select>
                      <%}else{%>
                      <%	if(base.getRent_way().equals("1")){%>
                        �Ϲݽ�
                        <%	}else if(base.getRent_way().equals("2")){%>
                        �����
                        <%	}else if(base.getRent_way().equals("3")){%>
                        �⺻��
                        <%	}%>
                        <input type='hidden' name="s_rent_way" value='<%=base.getRent_way()%>'>
                        <%}%></td>
                    <td width="100" align="center" class=title>��������</td>
                    <td  colspan="3"   class=b>&nbsp;
                      <select name="s_bus_st" disabled >
                        <option value=""  <%if(base.getBus_st().equals("")){%>selected<%}%>>����</option>
                        <option value="1" <%if(base.getBus_st().equals("1")){%>selected<%}%>>���ͳ�</option>
                        <option value="2" <%if(base.getBus_st().equals("2")){%>selected<%}%>>�������</option>
                        <option value="3" <%if(base.getBus_st().equals("3")){%>selected<%}%>>������ü�Ұ�</option>
                        <option value="4" <%if(base.getBus_st().equals("4")){%>selected<%}%>>catalog�߼�</option>
                        <option value="5" <%if(base.getBus_st().equals("5")){%>selected<%}%>>��ȭ���</option>
                        <option value="6" <%if(base.getBus_st().equals("6")){%>selected<%}%>>������ü</option>
                        <option value="7" <%if(base.getBus_st().equals("7")){%>selected<%}%>>������Ʈ</option>
                        <option value="8" <%if(base.getBus_st().equals("8")){%>selected<%}%>>�����</option>
                      </select></td>
                 
                </tr>		  
                <tr> 
                    <td width="110" align="center" class=title>�뿩����</td>
                    <td width="160" class=b>&nbsp;
                      <input type='text' name="t_con_mon" value='<%=base.getCon_mon()%>' size="4" class='whitetext' maxlength="2" onBlur='javascript:set_con_ff(); set_cont_date(this);' readonly >
                    ���� </td>
                    <td width="100" align="center" class=title>�뿩�Ⱓ</td>
                    <td colspan="5" class=b>&nbsp;
                      <input type="text" name="t_rent_start_dt" value="<%=base.getRent_start_dt()%>" size="12" maxlength='12' class=whitetext onBlur='javascript:this.value=ChangeDate(this.value); set_cont_date(this);' readonly >
                    ~
                    <input type="text" name="t_rent_end_dt" value="<%=base.getRent_end_dt()%>" size="12" maxlength='12' class=whitetext onBlur='javascript:this.value=ChangeDate(this.value)' readonly ></td>
                
                </tr>
                <tr> 
                    <td width="110" align="center" class=title>���ʿ�����</td>
                    <td width="160" class=b>&nbsp; <%=c_db.getNameById(base.getBus_id(),"USER")%>            
                    </td>
                    <td width="110" align="center" class=title>�����븮��</td>
                    <td width="160" class=b>&nbsp;<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%>             
                    </td>
                    <td width="100" align="center" class=title>���������</td>
                    <td width="160" class=b>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%>        
                    </td>    
                    </td>
                    <td width="100"  class=title align="center">���������</td>
                    <td width="160"  class=b>&nbsp;<%=c_db.getNameById(base.getMng_id(),"USER")%>                      
                    </td>
                
                </tr>
            </table>
        </td>
    </tr>
</table>
  <hr>
</form>
</body>
</html>
