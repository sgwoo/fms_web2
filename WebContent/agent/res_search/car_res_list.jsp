<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.secondhand.*, acar.insur.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="shDb" scope="page" class="acar.secondhand.SecondhandDatabase"/>
<jsp:useBean id="oh_db" 	class="acar.off_ls_hpg.OfflshpgDatabase" 	scope="session"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	LoginBean login = LoginBean.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();	
	


	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 		= request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String brch_id 		= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt 	= request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt 		= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");		
	String car_comp_id 	= request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc 		= request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	String s_year 		= request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_kd 		= request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")==null?"a.car_nm":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")==null?"asc":request.getParameter("asc");
	
	
	//�α���ID&������ID&����	
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "22", "05", "03");
	
	
	String c_id 		= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");	
	String rent_st 		= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String rent_start_dt 	= request.getParameter("rent_start_dt")==null?"":request.getParameter("rent_start_dt");
	String rent_end_dt 	= request.getParameter("rent_end_dt")==null?"":request.getParameter("rent_end_dt");
	
	
	//��������
	Hashtable res = rs_db.getCarInfo(c_id);

	
	//�縮���������� �������
	Vector sr = shDb.getShResList(c_id);
	int sr_size = sr.size();

	
	//������Ȳ
	Vector conts = rs_db.getResCarList(c_id);
	int cont_size = conts.size();
	
	
	//��������
	String ins_st = ai_db.getInsSt(c_id);
	InsurBean ins = ai_db.getIns(c_id, ins_st);
	String ins_com_nm = ai_db.getInsComNm(c_id);
	
	//�ֱ� Ȩ������ ����뿩�� - ����Ʈ
	Hashtable hp = oh_db.getSecondhandCaseRm("", "", c_id);	


	
	int use_cnt = 0;
	int rent_cnt = 0;
	
	String hp_rm_yn="N";
		
%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
<!--
	//�����ϱ�
	function reservation(){
		var fm = document.form1;
		
		if(fm.hp_rm_yn.value == 'N'){
			fm.rent_start_dt.value 	= fm.rent_start_dt_y.value+fm.rent_start_dt_m.value+fm.rent_start_dt_d.value;
			fm.rent_end_dt.value 	= fm.rent_end_dt_y.value+fm.rent_end_dt_m.value+fm.rent_end_dt_d.value;
		
			if(fm.rent_st.value == '11' && toInt(fm.rent_cnt.value) > 0 ){ alert('�̹� ������ ����Ǿ� �ֽ��ϴ�.'); return; }
				
			if(fm.rent_start_dt.value == ''){ alert("�뿩�������� �����ϴ�. ��¥�� �����Ͻʽÿ�."); return; }		
			if(ChangeDate4_chk(fm.rent_start_dt, fm.rent_start_dt.value) == ''){ alert("�뿩�������� Ȯ���Ͻʽÿ�. �������� ���ڰ� �ƴմϴ�."); 	return; }		
		
			//������ ���������� �ʼ��Է� �׸����� ����!!
			if(fm.rent_st.value == '2' || fm.rent_st.value == '3' || fm.rent_st.value == '9' || fm.rent_st.value == '10'){
				if(fm.rent_end_dt.value == '') { alert("���������� �Է��� �ʼ��׸� �Դϴ�!"); return; }
				if(ChangeDate4_chk(fm.rent_end_dt, fm.rent_end_dt.value) == '') 	{ alert("������������ Ȯ���Ͻʽÿ�. �������� ���ڰ� �ƴմϴ�."); 	return; }
			}
		
			if(fm.rent_end_dt.value != '' && fm.rent_start_dt.value > fm.rent_end_dt.value){ alert("�뿩�������� �뿩������ ���� �۽��ϴ�. Ȯ���Ͻʽÿ�."); return; }
				
		
			if(toInt(fm.use_cnt.value) > 0 && !confirm('���� Ȥ�� �����߿� �ִ� �����Դϴ�.\n\n�����Ͻðڽ��ϱ�?')){	return;	}
			
			if(<%=sr_size%> > 0 && !confirm('�ش� ������ �縮�� �� <%=sr_size%>���� ���� ������Դϴ�. �������ڵ鿡�� Ȯ�� �� ���� ��������')){	return;	}
		
			fm.target = "d_content";
			fm.action = "res_rent_i.jsp";
			fm.submit();
		
		}else{
			alert('���� ����Ʈ���� ������ ���Դϴ�. ����� �� �����ϴ�.');
			return;
		}		
	}	
	
	function ReLoadRes(c_id){
		var fm = document.form1;
		fm.c_id.value = c_id;
		fm.target = "d_content";
		fm.action = "car_res_list.jsp";
		fm.submit();
	}
	

	
	//�뿩�ϼ� ���ϱ�
	function getRentTime(st, dt1, dt2) {
		var fm = document.form1;	
		m  = 30*24*60*60*1000;		//��
		l  = 24*60*60*1000;  		// 1��
		lh = 60*60*1000;  			// 1�ð�
		lm = 60*1000;  	 	 		// 1��
		var rent_time = "";
		var d1;
		var d2;
		var t1;
		var t2;
		var t3;		
					
		if(dt1 != '' && dt2 != ''){
			d1 = replaceString('-','',dt1)+'00'+ '00';
			d2 = replaceString('-','',dt2)+'00'+ '00';		

			t1 = getDateFromString(d1).getTime();
			t2 = getDateFromString(d2).getTime();
			t3 = t2 - t1;
			
			if(st == 'm') 			rent_time = parseInt(t3/m);
			if(st == 'd') 			rent_time = parseInt(t3/l);			
			
			return rent_time;
			
		}
	}
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}
	
				
//-->
</script>
</head>
<body leftmargin="15">

<form name="form1" method="post" action="res_rent_i.jsp">
<input type='hidden' name='c_id' value='<%=c_id%>'>
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
 <input type='hidden' name='rent_start_dt' value=''>
 <input type='hidden' name='rent_end_dt' value=''>
 <input type='hidden' name='ins_st' value='<%=ins_st%>'>  
 <input type='hidden' name='s_cd' value=''>  
 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�����������</span></span></td>
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
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title>������ȣ</td>
                    <td> 
                      &nbsp;<%=res.get("CAR_NO")%>
                    </td>
                    <td class=title>����</td>
                    <td align="left" colspan="3">&nbsp;<%=res.get("CAR_NM")%>&nbsp;<%=res.get("CAR_NAME")%></td>
                    <td class=title>�����ȣ</td>
                    <td align="left" colspan="3">&nbsp;<%=res.get("CAR_NUM")%></td>
                </tr>
                <tr> 
                    <td class=title width=10%>���ʵ����</td>
                    <td width=10%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(res.get("INIT_REG_DT")))%></td>
                    <td class=title width=10%>�������</td>
                    <td width=10%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(res.get("DLV_DT")))%></td>
                    <td class=title width=10%>��ⷮ</td>
                    <td width=10%>&nbsp;<%=res.get("DPM")%>cc</td>
                    <td class=title width=10%>Į��</td>
                    <td width=10%>&nbsp;<%=res.get("COLO")%></td>
                    <td class=title width=10%>����</td>
                    <td width=10%">&nbsp;<%=res.get("FUEL_KD")%></td>
                </tr>
                <tr> 
                    <td class=title>���û��</td>
                    <td colspan="5">&nbsp;<%=res.get("OPT")%></td>
                    <td class=title>����Ÿ�</td>
                    <td>&nbsp;<%=Util.parseDecimal(String.valueOf(res.get("TODAY_DIST")))%>km</td>
                    <td class=title>����������</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(res.get("SERV_DT")))%></td>
                </tr>
                <tr> 
                    <td class=title width=10%>�˻���ȿ�Ⱓ</td>
                    <td width=23% colspan="3">&nbsp; 
                      <input type="text" name="maint_st_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(res.get("MAINT_ST_DT")))%>" size="10" class=whitetext>
                      ~ 
                      <input type="text" name="maint_end_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(res.get("MAINT_END_DT")))%>" size="10" class=whitetext>
                      &nbsp; </td>
                    <td class=title>���ɸ�����</td>
                    <td>&nbsp; 
                      <input type="text" name="car_end_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(res.get("CAR_END_DT")))%>" size="10" class=whitetext>
                    </td>
                    <td class=title>������ȿ�Ⱓ</td>
                    <td colspan="3">&nbsp; 
                      <input type="text" name="test_st_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(res.get("TEST_ST_DT")))%>" size="10" class=whitetext>
                      ~&nbsp; 
                      <input type="text" name="test_end_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(res.get("TEST_END_DT")))%>" size="10" class=whitetext>
                    </td>
                </tr>
                <!--��������-->
                <tr> 
                    <td class=title>����ȸ��</td>
                    <td >&nbsp;<%=ins_com_nm%>
        			<%if(ins.getVins_spe().equals("�ִ�ī")){%>(�ִ�ī)<%}%>
        			</td>
                  <td class=title>�Ǻ�����</td>
                  <td>&nbsp;<%if(ins.getCon_f_nm().equals("�Ƹ���ī")){%><%=ins.getCon_f_nm()%><%}else{%><b><font color='#990000'><%=ins.getCon_f_nm()%></font></b><%}%></td>
                  <td class=title>���迬��</td>
                  <td colspan="5">&nbsp;
                    	<%if(ins.getAge_scp().equals("1")){%>21���̻�<%}%>
                        <%if(ins.getAge_scp().equals("4")){%>24���̻�<%}%>
                        <%if(ins.getAge_scp().equals("2")){%>26���̻�<%}%>
                        <%if(ins.getAge_scp().equals("3")){%>������<%}%>
                        <%if(ins.getAge_scp().equals("5")){%>30���̻�<%}%>
                        <%if(ins.getAge_scp().equals("6")){%>35���̻�<%}%>
                        <%if(ins.getAge_scp().equals("7")){%>43���̻�<%}%>
			<%if(ins.getAge_scp().equals("8")){%>48���̻�<%}%>
                  </td>          			
                </tr> 
            </table>
        </td>
    </tr>    
    <tr> 
        <td class=h></td>
    </tr>
	<%if(sr_size>0){%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�縮�� ��������</span></td>
    <tr>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
				<%	for(int i = 0 ; i < sr_size ; i++){
						Hashtable sr_ht = (Hashtable)sr.elementAt(i);
						%>
                <tr> 
                    <td class="title" width="10%">����</td>					
                    <td align="center" width="10%"><%	if(String.valueOf(sr_ht.get("SITUATION")).equals("0"))			out.print("�����");
        												else if(String.valueOf(sr_ht.get("SITUATION")).equals("2"))		out.print("���Ȯ��");  %>
        													
        											<%if(!String.valueOf(sr_ht.get("REG_CODE")).equals("")){
        													hp_rm_yn = "Y";
        											%>
        											<br>
        											<font color='red'><b>�� ����Ʈ����</b></font>
        											<%}%>
        						</td>
                    <td class="title" width="10%">����Ⱓ</td>					
                    <td align="center" width="20%"><%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_ST_DT"))) %>~<%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_END_DT"))) %></td>															
                    <td class="title" width="10%">�����</td>					
                    <td align="center" width="10%"><%=c_db.getNameById(String.valueOf(sr_ht.get("DAMDANG_ID")),"USER")%></td>															
                    <td class="title" width="10%">�޸�</td>
                    <td width="20%"><%=sr_ht.get("CUST_NM")%>&nbsp;<%=sr_ht.get("CUST_TEL")%>&nbsp;<%=sr_ht.get("MEMO")%></td>															
                </tr>						
				<%}%>
            </table>
	    </td>
    </tr>	
	<%}%>
	<input type="hidden" name="hp_rm_yn" value="<%=hp_rm_yn%>">    
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����</span></td>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table cellspacing=1 cellpadding=0 width="100%" border=0>
                <tr> 
                    <td width=10% class=title>����</td>
                    <td width=10%> 
                      &nbsp;<select name="rent_st">
                        <option value="10" <%if(rent_st.equals("10"))%>selected<%%>>��������</option>
                      </select>
                    </td>
                    <td width=10% class=title>�뿩�Ⱓ</td>
                    <td align=center> 
                        <select name="rent_start_dt_y" onchange="javascript:rent_end_set_display();">
                            <%for(int i=AddUtil.getDate2(1); i<AddUtil.getDate2(1)+2; i++){%>
                            <option value="<%=i%>"><%=i%>��</option>
                            <%}%>
                          </select>
                          <select name="rent_start_dt_m" onchange="javascript:rent_end_set_display();">
                            <%for(int i=1; i<=12; i++){%>
                            <option value="<%=AddUtil.addZero2(i)%>" <%if(AddUtil.getDate2(2)==i)%>selected<%%>><%=AddUtil.addZero2(i)%>��</option>
                            <%}%>
                          </select>
                          <select name="rent_start_dt_d" onchange="javascript:rent_end_set_display();">
                            <%for(int i=1; i<=31; i++){%>
                            <option value="<%=AddUtil.addZero2(i)%>" <%if(AddUtil.getDate2(3)==i)%>selected<%%>><%=AddUtil.addZero2(i)%>��</option>
                            <%}%>
                          </select>
                          ~ 			  
                          <select name="rent_end_dt_y">
                            <option value="">����</option>			  			  
                            <%for(int i=AddUtil.getDate2(1); i<AddUtil.getDate2(1)+2; i++){%>
                            <option value="<%=i%>"><%=i%>��</option>
                            <%}%>
                          </select>
                          <select name="rent_end_dt_m">
                            <option value="">����</option>			  			  
                            <%for(int i=1; i<=12; i++){%>
                            <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>��</option>
                            <%}%>
                          </select>
                          <select name="rent_end_dt_d">
                            <option value="">����</option>			  
                            <%for(int i=1; i<=31; i++){%>
                            <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>��</option>
                            <%}%>
                          </select>                                	
                    </td>
                    <td width=19% align=center>        		  
        			<a href="javascript:reservation();" onFocus="this.blur()"><img src=/acar/images/center/button_in_yy.gif align=absmiddle border=0></a>        		  
        			</td>
                </tr>
            </table>
        </td>
    </tr>				
    <tr> 
        <td></td>
    </tr>

    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���� �̷�</span></td>
    <tr>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="1" width=100%>
                <tr> 
                    <td class=title rowspan='2' width="3%">����</td>
                    <td class=title rowspan='2' width="8%">����</td>
                    <td class=title rowspan='2' width="4%">����</td>
                    <td class=title colspan='2'>�ڵ���</td>										
                    <td class=title rowspan='2' width="17%">�뿩�Ⱓ</td>
                    <td class=title rowspan='2' width="23%">��ȣ/����</td>					
                    <td class=title rowspan='2' width="7%">�������</td>
                    <td class=title rowspan='2' width="7%">�������</td>			
                    <td class=title rowspan='2' width="6%">�����</td>
                    <td class=title rowspan='2' width="9%">�������</td>
                    
                </tr>
				<tr>
                    <td class=title width="8%">������</td>														
                    <td class=title width="8%">�����߻�</td>																			
				</tr>				
              <%	if(cont_size > 0){
    				for(int i = 0 ; i < cont_size ; i++){
    					Hashtable reservs = (Hashtable)conts.elementAt(i);
    					if(String.valueOf(reservs.get("USE_ST")).equals("����") || String.valueOf(reservs.get("USE_ST")).equals("����")){
							use_cnt ++;
							if(String.valueOf(reservs.get("USE_ST")).equals("����") && String.valueOf(reservs.get("RENT_ST")).equals("�����")){
								rent_cnt ++;
							}
						}
						
    					%>
                <tr> 
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("����")&&!String.valueOf(reservs.get("USE_ST")).equals("����"))%>class="title_p"<%%> align="center"><%=i+1%></td>
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("����")&&!String.valueOf(reservs.get("USE_ST")).equals("����"))%>class="title_p"<%%> align="center"><%=reservs.get("RENT_ST")%></td>
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("����")&&!String.valueOf(reservs.get("USE_ST")).equals("����"))%>class="title_p"<%%> align="center"><%=reservs.get("USE_ST")%></td>
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("����")&&!String.valueOf(reservs.get("USE_ST")).equals("����"))%>class="title_p"<%%> align="center"><%=reservs.get("CAR_NO")%></td>
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("����")&&!String.valueOf(reservs.get("USE_ST")).equals("����"))%>class="title_p"<%%> align="center"><%=reservs.get("D_CAR_NO")%><br><%=reservs.get("D_CAR_NM")%></td>										
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("����")&&!String.valueOf(reservs.get("USE_ST")).equals("����"))%>class="title_p"<%%> align="center"><%=AddUtil.ChangeDate3(String.valueOf(reservs.get("DELI_DT")))%><br>~<%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RET_DT")))%></td>
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("����")&&!String.valueOf(reservs.get("USE_ST")).equals("����"))%>class="title_p"<%%> align="center"><%=reservs.get("FIRM_NM")%> <%=reservs.get("CUST_NM")%></td>                    
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("����")&&!String.valueOf(reservs.get("USE_ST")).equals("����"))%>class="title_p"<%%> align="center"><%=reservs.get("BUS_NM")%></td>					
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("����")&&!String.valueOf(reservs.get("USE_ST")).equals("����"))%>class="title_p"<%%> align="center"><%=reservs.get("MNG_NM")%></td>					
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("����")&&!String.valueOf(reservs.get("USE_ST")).equals("����"))%>class="title_p"<%%> align="center"><%=reservs.get("REG_NM")%></td>					
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("����")&&!String.valueOf(reservs.get("USE_ST")).equals("����"))%>class="title_p"<%%> align="center"><%=AddUtil.ChangeDate3_2(String.valueOf(reservs.get("REG_DT")))%></td>					
                </tr>
              <%		}
      			}else{%>
                <tr> 
                    <td colspan='11' align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
                </tr>
              <%	}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
	<!--	
    <tr> 
      <td>&lt; ���డ�� ��¥ ��ȸ&gt;</td>
    </tr>	
    <tr> 
      <td>
	    <table width="100%" border="0" cellspacing="0" cellpadding="0">
  		  <tr>
    		<td><iframe src="calendar_s.jsp?c_id=<%=c_id%>" name="inner_s" width="300" height="290" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
        	</iframe></td>
    		<td><iframe src="calendar_e.jsp?c_id=<%=c_id%>" name="inner_e" width="300" height="290" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
        	</iframe></td>
  		  </tr>
		</table>
	  </td>
    </tr>
	-->
</table>
<input type='hidden' name='use_cnt' value='<%=use_cnt%>'>
<input type='hidden' name='rent_cnt' value='<%=rent_cnt%>'>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
