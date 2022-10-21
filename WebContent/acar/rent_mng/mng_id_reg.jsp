<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.user_mng.*, acar.cont.* "%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");		
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"a.car_nm":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");

	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");		
	String f_page = request.getParameter("f_page")==null?"":request.getParameter("f_page");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String list_from_page = request.getParameter("list_from_page")==null?"":request.getParameter("list_from_page");
	
	
	String mngid_reg_brch_id = request.getParameter("mngid_reg_brch_id")==null?"":request.getParameter("mngid_reg_brch_id");
	
	//�α���ID&������ID&����
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	auth_rw = rs_db.getAuthRw(user_id, "02", "01", "03");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	//����� ����Ʈ
	Vector users = new Vector();
	
	if(mngid_reg_brch_id.equals("S1")){	
		users = c_db.getUserList("0002", "", "RM_MNG"); 
	}else if(mngid_reg_brch_id.equals("S2")){	
		users = c_db.getUserList("0002", "", "RM_MNG"); 
	}else if(mngid_reg_brch_id.equals("I1")){	
		users = c_db.getUserList("0002", "", "RM_MNG"); 
	}else if(mngid_reg_brch_id.equals("K3")){	
		users = c_db.getUserList("", "", "RM_MNG_K3");
	}else if(mngid_reg_brch_id.equals("B1")){	
		users = c_db.getUserList("", "", "RM_MNG_B");
	}else if(mngid_reg_brch_id.equals("D1")){	
		users = c_db.getUserList("", "", "RM_MNG_D");
	}else{
		users = c_db.getUserList("0002", "", "RM_MNG"); 
	}
	
	if(!mngid_reg_brch_id.equals("S1") && br_id.equals("S1")){	
		users = c_db.getUserList("0002", "", "RM_MNG"); 
	}
	
	int user_size = users.size();	

	//��������
	Hashtable reserv = rs_db.getCarInfo(c_id);
	
	//�ܱ�������
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	//������
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
	String rent_st = rc_bean.getRent_st();
	
		
	//�����
	user_bean 	= umd.getUsersBean(rc_bean.getMng_id());
	
	
	//���Ͼ�ü ����ڰ� ������ ǥ������
	Vector mngs = rs_db.getRentContCustHList(rc_bean.getRent_st(), rc_bean.getCust_id(), rc_bean.getRent_s_cd());
	int mng_size = mngs.size();
	
	//����������
	Hashtable cont = a_db.getContViewUseYCarCase(c_id);
	

%>

<html>
<head>

<title>����ý��� <%if(mode.equals("R")){%>����ó��<%}else{%>�Ⱓ����<%}%></title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
	//�����ϱ�
	function save(){
		var fm = document.form1;
		if(fm.mng_id.value == ''){ alert('������ ��������ڸ� �����Ͻʽÿ�'); fm.mng_id.focus(); return; }	
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
		fm.action = 'mng_id_reg_a.jsp';
		fm.target = 'i_no';
		fm.submit();			
	}
	
		
</script>
</head>
<body>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<form action="" name="form1" method="post" >
 <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
 <input type='hidden' name='user_id' value='<%=user_id%>'>
 <input type='hidden' name='br_id' value='<%=br_id%>'>
 <input type='hidden' name='gubun1' value='<%=gubun1%>'>  
 <input type='hidden' name='gubun2' value='<%=gubun2%>'>   
 <input type='hidden' name='brch_id' value='<%=brch_id%>'> 
 <input type='hidden' name='start_dt' value='<%=start_dt%>'> 
 <input type='hidden' name='end_dt' value='<%=end_dt%>'>   
 <input type='hidden' name='car_comp_id' value='<%=car_comp_id%>'>   
 <input type='hidden' name='code' value='<%=code%>'>     
 <input type='hidden' name='s_kd'  value='<%=s_kd%>'>
 <input type='hidden' name='t_wd' value='<%=t_wd%>'>			 
 <input type='hidden' name='s_cc' value='<%=s_cc%>'>
 <input type='hidden' name='s_year' value='<%=s_year%>'> 
 <input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'> 
 <input type='hidden' name='asc' value='<%=asc%>'> 
 <input type='hidden' name='car_no' value='<%=reserv.get("CAR_NO")%>'>        
 <input type='hidden' name='c_firm_nm' value='<%=rc_bean2.getFirm_nm()%>'>         
 <input type='hidden' name='c_client_nm' value='<%=rc_bean2.getCust_nm()%>'>    
 <input type='hidden' name='from_page' value='<%=from_page%>'>
 <input type='hidden' name='list_from_page' value='<%=list_from_page%>'>


<input type='hidden' name='s_cd' value='<%=s_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
       
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>����ý��� > ����Ʈ���� > <span class=style5>��������� ����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ ����</span></td>
    </tr>    
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <tr> 
                    <td width='15%' class='title'>����ȣ</td>
                    <td colspan="3">&nbsp;<%=cont.get("RENT_L_CD")%></td>
                  </tr>                  
                  <tr> 
                    <td width='15%' class='title'>���������</td>
                    <td width='35%'>&nbsp;<%=c_db.getNameById(String.valueOf(cont.get("BUS_ID2")),"USER")%></td>                    
                    <td width='15%' class='title'>���������</td>
                    <td width='35%'>&nbsp;<%=c_db.getNameById(String.valueOf(cont.get("MNG_ID")),"USER")%></td>                    
                  </tr>                  
                </table>
	    </td>	    
	</tr>  
    <tr>
        <td class=h></td>
    </tr>  	
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����Ʈ ����</span></td>
    </tr>              
    <tr><td class=line2></td></tr>  
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='15%' class=title>��౸��</td>
                    <td width='35%'> 
                      <%if(rent_st.equals("1")){%>
                      &nbsp;�ܱ�뿩 
                      <%}else if(rent_st.equals("2")){%>
                      &nbsp;������� 
                      <%}else if(rent_st.equals("3")){%>
                      &nbsp;������ 
                      <%}else if(rent_st.equals("9")){%>
                      &nbsp;������� 			  
                      <%}else if(rent_st.equals("10")){%>
                      &nbsp;�������� 			  
                      <%}else if(rent_st.equals("4")){%>
                      &nbsp;�����뿩 
                      <%}else if(rent_st.equals("5")){%>
                      &nbsp;�������� 
                      <%}else if(rent_st.equals("6")){%>
                      &nbsp;�������� 
                      <%}else if(rent_st.equals("7")){%>
                      &nbsp;�������� 
                      <%}else if(rent_st.equals("8")){%>
                      &nbsp;������ 
                      <%}else if(rent_st.equals("11")){%>
                      &nbsp;��Ÿ 
                      <%}else if(rent_st.equals("12")){%>
                      &nbsp;����Ʈ
                      <%}%>
                    </td>
                    <td class=title width=15%>������ȣ</td>
                    <td width=35%>&nbsp;<%=reserv.get("CAR_NO")%></td>
                <tr>                     
                    <td class=title>����</td>
                    <td>&nbsp;<%=rc_bean2.getCust_nm()%></td>
                    <td class=title>��ȣ</td>
                    <td>&nbsp;<%=rc_bean2.getFirm_nm()%></td>
                </tr>
                <tr> 
                    <td class=title>�뿩�Ⱓ</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRent_start_dt())%>
                     ~ <%=AddUtil.ChangeDate3(rc_bean.getRent_end_dt())%></td>
                </tr>
                <tr> 
                    <td class=title>�����Ͻ�</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getDeli_dt())%></td>
                    <td class=title>���ʿ�����</td>
                    <td>&nbsp;<%=c_db.getNameById(rc_bean.getBus_id(),"USER")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>      	
    <tr><td class=line2></td></tr> 
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title rowspan="2" width=15%>���������</td>
                    <td class=title width=15%>������</td>
                    <td>
                      &nbsp;<%=user_bean.getUser_nm()%>
                    </td>
                </tr>
                <tr> 
                    <td class=title>������</td>
                    <td> 
                      &nbsp;<select name='mng_id'>
                        <option value="">������</option>
                        <%if(mngid_reg_brch_id.equals(br_id)){	%>
                        <%if(mngid_reg_brch_id.equals("B1")){%>
                        <option value='000053' >������</option>	
                        <%}%>
                        <%if(mngid_reg_brch_id.equals("D1")){%>
                        <option value='000052' >�ڿ���</option>		
                        <%}%>
                        <%}%>
                        <%if(user_size > 0){
        					for (int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(rc_bean.getBus_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}%>
        		<%if(br_id.equals("S1")){
        			users = c_db.getUserList("", "", "WATCH_B");
        			user_size = users.size();	%>
        		<option value='' >==�λ�����==</option>	
        		
        		<%if(user_size > 0){
        					for (int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(rc_bean.getBus_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}%>
        		<%	users = c_db.getUserList("", "", "WATCH_D");
        			user_size = users.size();%>
        		<option value='' >==��������==</option>	
        		
			<%if(user_size > 0){
        					for (int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(rc_bean.getBus_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}%>        								        		
        		<%}%>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title colspan='2'>�ȳ�����</td>                    
                    <td>
                      &nbsp;<input type='checkbox' name='sms_reg' value='Y' checked> ������ ��������� ���� �ȳ����� �߼�
                    </td>
                </tr>                
            </table>
        </td>
    </tr>   
    <tr>
        <td>* ������ ����ڿ��� ���� �޽����� ���ϴ�.</td>
    </tr>  		
    <tr>
        <td>* �ȳ����ο� üũ�� ���¿��� �����ϸ� ������ �ȳ����ڰ� ���ϴ�.</td>
    </tr>  		
    <tr>
        <td class=h></td>
    </tr>  		
	<tr>
	    <td align="right">
	  	<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>		  	  	  
		 <a href='javascript:save();'><img src="/acar/images/center/button_conf.gif" border="0" align=absmiddle></a>
	  	<%}%>			
		&nbsp;<a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a>				
	    </td>
	</tr>
    <%	if(mng_size > 0){%>	
    <tr> 
        <td>[ �� ��������Ʈ ]</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>      	
    <tr><td class=line2></td></tr> 
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=6%>����</td>
                    <td class=title width=8%>��౸��</td>
                    <td class=title width=8%>���±���</td>
                    <td class=title width=10%>�������</td>
                    <td class=title width=10%>������ȣ</td>
                    <td class=title width=19%>�����Ͻ�</td>
                    <td class=title width=19%>�����Ͻ�</td>                    
                    <td class=title width=10%>���ʿ�����</td>
                    <td class=title width=10%>���������</td>                    
                </tr>    
    		<%	for(int i = 0 ; i < mng_size ; i++){
    				Hashtable mng = (Hashtable)mngs.elementAt(i);%>	
                <tr> 
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=mng.get("RENT_ST_NM")%></td>
                    <td align='center'><%=mng.get("USE_ST_NM")%></td>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(mng.get("RENT_DT")))%></td>
                    <td align='center'><%=mng.get("CAR_NO")%></td>
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(mng.get("DELI_DT")))%><%if(String.valueOf(mng.get("DELI_DT")).equals("")){%><%=AddUtil.ChangeDate3(String.valueOf(mng.get("DELI_PLAN_DT")))%><%}%></td>
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(mng.get("RET_DT")))%><%if(String.valueOf(mng.get("RET_DT")).equals("")){%><%=AddUtil.ChangeDate3(String.valueOf(mng.get("RET_PLAN_DT")))%><%}%></td>
                    <td align="center"><%=mng.get("BUS_NM")%></td>
                    <td align="center"><%=mng.get("MNG_NM")%></td>
                </tr>    
                <%	}%>
            </table>
        </td>
    </tr>       
    <%	}%>	
</table>
</form>
<script language="JavaScript">
<!--	
//-->
</script>
</body>
</html>
