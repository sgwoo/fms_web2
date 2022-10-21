<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.secondhand.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="shDb" 		class="acar.secondhand.SecondhandDatabase" 	scope="page"/>
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
	
	//�α���ID&������ID&����
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "01", "01");
	
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String rent_start_dt = request.getParameter("rent_start_dt")==null?"":request.getParameter("rent_start_dt");
	String rent_end_dt = request.getParameter("rent_end_dt")==null?"":request.getParameter("rent_end_dt");
	
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	
	//��������
	Hashtable res = rs_db.getCarInfo(c_id);
	
	//������Ȳ
	Vector conts = rs_db.getResCarList(c_id);
	int cont_size = conts.size();
	
	int use_cnt = 0;
	
	Vector sr = shDb.getShResList(c_id);
	int sr_size = sr.size();
	
%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
	//����Ʈ ����
	function go_to_list(){
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var br_id 	= fm.br_id.value;
		var user_id	= fm.user_id.value;						
		var gubun1 	= fm.gubun1.value;
		var gubun2 	= fm.gubun2.value;		
		var brch_id = fm.brch_id.value;
		var start_dt = fm.start_dt.value;
		var end_dt = fm.end_dt.value;				
		var car_comp_id = fm.car_comp_id.value;				
		var code = fm.code.value;				
		var s_cc 	= fm.s_cc.value;
		var s_year 	= fm.s_year.value;				
		var s_kd 	= fm.s_kd.value;
		var t_wd 	= fm.t_wd.value;
		var sort_gubun = fm.sort_gubun.value;
		var asc 	= fm.asc.value;
		location = "/acar/res_search/res_se_frame_s.jsp?auth_rw="+auth_rw+"&gubun1="+gubun1+"&gubun2="+gubun2+"&brch_id="+brch_id+"&start_dt="+start_dt+"&end_dt="+end_dt+"&car_comp_id="+car_comp_id+"&code="+code+"&s_kd="+s_kd+"&t_wd="+t_wd+"&s_cc="+s_cc+"&s_year="+s_year+"&sort_gubun="+sort_gubun+"&asc="+asc;
	}	
	
	function reservation(){
		var fm = document.form1;
		fm.rent_start_dt.value 	= fm.rent_start_dt_y.value+fm.rent_start_dt_m.value+fm.rent_start_dt_d.value;
		fm.rent_end_dt.value 	= fm.rent_end_dt_y.value+fm.rent_end_dt_m.value+fm.rent_end_dt_d.value;	
		if(fm.rent_start_dt.value == ''){ alert("�뿩�������� �����ϴ�. ��¥�� �����Ͻʽÿ�."); return; }		
//		if(fm.rent_end_dt.value == '' && fm.rent_st.value == '1'){ alert("�뿩�������� �Է��Ͻʽÿ�."); return; }
		if(fm.rent_end_dt.value != '' && fm.rent_start_dt.value > fm.rent_end_dt.value){ alert("�뿩�������� �뿩������ ���� �۽��ϴ�. Ȯ���Ͻʽÿ�."); return; }	
		
		if(toInt(fm.use_cnt.value) > 0 && !confirm('���� Ȥ�� �����߿� �ִ� �����Դϴ�.\n\n�����Ͻðڽ��ϱ�?')){	return;	}
					
		fm.action = "/acar/res_search/res_rent_i.jsp";
		fm.target = "d_content";
		fm.submit();
		self.close();
	}	

	function CarRentSearch(car_no) {
		var keyValue = event.keyCode;	
		if (keyValue =='13'){
			var SUBWIN="./car_rent_list.jsp?gubun=car_no&rent_l_cd=&firm_nm=&car_no="+car_no;	
			window.open(SUBWIN, "CarRentList", "left=100, top=100, width=700, height=400, scrollbars=yes");
		}
		return;
	}	
	
	function ReLoadRes(c_id){
		var fm = document.form1;
		fm.c_id.value = c_id;
		fm.action = "car_res_list.jsp";
		fm.submit();
	}

	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	
	
	//�ڵ���������� ����
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=&rent_l_cd=&car_mng_id=<%=c_id%>&cmd=ud", "VIEW_CAR", "left=100, top=100, width=850, height=700, scrollbars=yes");
	}			
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
 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>����ý��� > ������ȸ > <span class=style5>������ ����/�뿩 ����Ʈ</span></span></td>
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
                    <td class=title width="13%">������ȣ</td>
                    <td> 
                      &nbsp;<input type="text" name="car_no" size="10" value="<%=res.get("CAR_NO")%>" class='text' onKeydown="CarRentSearch(this.value)">
                    </td>
                    <td class=title>����</td>
                    <td align="left" colspan="3">&nbsp;<%=res.get("CAR_NM")%>&nbsp;<%=res.get("CAR_NAME")%></td>
                    <td class=title width="13%">�����ȣ</td>
                    <td align="left" colspan="3">&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=res.get("CAR_NUM")%></a></td>
                </tr>
                <tr> 
                    <td class=title width=10%>���ʵ����</td>
                    <td width=11%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(res.get("INIT_REG_DT")))%></td>
                    <td class=title width=8%>�������</td>
                    <td width=10%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(res.get("DLV_DT")))%></td>
                    <td class=title width=14%>��ⷮ</td>
                    <td width=8%>&nbsp;<%=res.get("DPM")%>cc</td>
                    <td class=title width=10%>Į��</td>
                    <td width=10%>&nbsp;<%=res.get("COLO")%></td>
                    <td class=title width=6%>����</td>
                    <td width=13%>&nbsp;<%=res.get("FUEL_KD")%></td>
                </tr>
                <tr> 
                    <td class=title>���û��</td>
                    <td colspan="3">&nbsp;<%=res.get("OPT")%></td>
                    <td class=title>���翹������Ÿ�</td>
                    <td>&nbsp;<%=Util.parseDecimal(String.valueOf(res.get("TODAY_DIST")))%>km</td>
                    <td class=title>����������</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(res.get("SERV_DT")))%></td>
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
            </table>
        </td>
    </tr>
    <tr> 
        <td height="21" align="right"><!--<a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src="/images/list.gif" width="50" height="18" aligh="absmiddle" border="0"></a>--></td>
    </tr>
	<%if(1!=1){%>
    <tr> 
        <td>
            <table bordercolor=#8f8f8f cellspacing=0 bordercolordark=white cellpadding=5 width="100%" bordercolorlight=#8f8f8f border=1>
                <tbody> 
                <tr align="center"> 
                    <td width="50"> 
                      <p>����</p>
                    </td>
                    <td width="90"> 
                      <select name="rent_st">
                        <option value="1" <%if(rent_st.equals("1"))%>selected<%%>>�ܱ�뿩</option>
                        <option value="2" <%if(rent_st.equals("2"))%>selected<%%>>�������</option>
                        <option value="3" <%if(rent_st.equals("3"))%>selected<%%>>������</option>
                        <option value="9" <%if(rent_st.equals("9"))%>selected<%%>>�������</option>
                        <option value="10" <%if(rent_st.equals("10"))%>selected<%%>>��������</option>
                        <option value="4" <%if(rent_st.equals("4"))%>selected<%%>>�����뿩</option>
        <!--            <option value="5" <%if(rent_st.equals("5"))%>selected<%%>>��������</option>-->
                        <option value="6" <%if(rent_st.equals("6"))%>selected<%%>>��������</option>
        <!--            <option value="7" <%if(rent_st.equals("7"))%>selected<%%>>��������</option>-->
                        <option value="8" <%if(rent_st.equals("8"))%>selected<%%>>������</option>
                        <option value="11" <%if(rent_st.equals("11"))%>selected<%%>>�����</option>
                        <option value="12" <%if(rent_st.equals("12"))%>selected<%%>>����Ʈ</option>
                      </select>
                    </td>
                    <td width="60">�뿩�Ⱓ</td>
                    <td> 
                      <select name="rent_start_dt_y">
                        <%for(int i=AddUtil.getDate2(1); i<AddUtil.getDate2(1)+2; i++){%>
                        <option value="<%=i%>"><%=i%>��</option>
                        <%}%>
                      </select>
                      <select name="rent_start_dt_m">
                        <%for(int i=1; i<=12; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(AddUtil.getDate2(2)==i)%>selected<%%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="rent_start_dt_d">
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
        			  <!--			
                      <input type="text" name="rent_start_dt" size="10" readonly value="<%=rent_start_dt%>">
                      ~ 
                      <input type="text" name="rent_end_dt" size="10" readonly value="<%=rent_end_dt%>">
        			  -->
                    </td>
                    <td width="90">
        	  	<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>		  	  	  			
        			<a href="javascript:reservation();" onFocus="this.blur()"><img src="/images/reservation.gif" border=0 width="88" height="27"></a></td>
        	  	<%}else{%>&nbsp;<%}%>						
                </tr>
                </tbody> 
            </table>
        </td>
    </tr>	
    <tr> 
        <td>&nbsp;</td>
    </tr>	
	<%}%>		
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
				<%	for(int i = 0 ; i < 1 ; i++){
						Hashtable sr_ht = (Hashtable)sr.elementAt(i);
						%>
                <tr> 
                    <td class="title" width="10%">����</td>					
                    <td align="center" width="10%"><%	if(String.valueOf(sr_ht.get("SITUATION")).equals("0"))			out.print("�����");
        												else if(String.valueOf(sr_ht.get("SITUATION")).equals("2"))		out.print("���Ȯ��");  %></td>										
                    <td class="title" width="10%">����Ⱓ</td>					
                    <td align="center" width="20%"><%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_ST_DT"))) %>~<%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_END_DT"))) %></td>															
                    <td class="title" width="10%">�����</td>					
                    <td align="center" width="10%"><%=c_db.getNameById(String.valueOf(sr_ht.get("DAMDANG_ID")),"USER")%></td>															
                    <td class="title" width="10%">�޸�</td>
                    <td width="20%"><%=sr_ht.get("MEMO")%></td>															
                </tr>						
				<%}%>
            </table>
	    </td>
    </tr>	
	<%}%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���� �̷�</span></td>
    <tr>			
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title rowspan='2' width="4%">����</td>
                    <td class=title rowspan='2' width="7%">����</td>
                    <td class=title rowspan='2' width="4%">����</td>
                    <td class=title colspan='2'>�ڵ���</td>										
                    <td class=title rowspan='2' width="18%">�뿩�Ⱓ</td>
                    <td class=title rowspan='2' width="24%">��ȣ/����</td>					
                    <td class=title rowspan='2' width="7%">�����</td>					
                    <td class=title rowspan='2' width="10%">�������</td>
                    <td class=title rowspan='2' width="6%">������</td>			
                </tr>
				<tr>
                    <td class=title width="10%">������</td>														
                    <td class=title width="10%">�����߻�</td>																			
				</tr>			
              <%	if(cont_size > 0){
    				for(int i = 0 ; i < cont_size ; i++){
    					Hashtable reservs = (Hashtable)conts.elementAt(i);
    					if(String.valueOf(reservs.get("USE_ST")).equals("����") || String.valueOf(reservs.get("USE_ST")).equals("����")) use_cnt ++;
    					%>
                <tr> 
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("����")&&!String.valueOf(reservs.get("USE_ST")).equals("����"))%>class="title_pn"<%%> align="center"><%=i+1%></td>
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("����")&&!String.valueOf(reservs.get("USE_ST")).equals("����"))%>class="title_pn"<%%> align="center"><%=reservs.get("RENT_ST")%></td>
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("����")&&!String.valueOf(reservs.get("USE_ST")).equals("����"))%>class="title_pn"<%%> align="center"><%=reservs.get("USE_ST")%></td>
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("����")&&!String.valueOf(reservs.get("USE_ST")).equals("����"))%>class="title_p"<%%> align="center"><%=reservs.get("CAR_NO")%></td>
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("����")&&!String.valueOf(reservs.get("USE_ST")).equals("����"))%>class="title_p"<%%> align="center"><%=reservs.get("D_CAR_NO")%></td>															
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("����")&&!String.valueOf(reservs.get("USE_ST")).equals("����"))%>class="title_pn"<%%> align="center"><%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RENT_START_DT")))%>��<br> ~ <%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RENT_END_DT")))%>��</td>
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("����")&&!String.valueOf(reservs.get("USE_ST")).equals("����"))%>class="title_pn"<%%> align="center"><a class=index1 href="javascript:MM_openBrWindow('rent_cont.jsp?c_id=<%=c_id%>&s_cd=<%=reservs.get("RENT_S_CD")%>&car_no=<%=res.get("CAR_NO")%>','RentCont','scrollbars=yes,status=yes,resizable=yes,width=850,height=800,left=10, top=10')"><%=reservs.get("FIRM_NM")%> <%=reservs.get("CUST_NM")%></a></td>
                    <!--<td <%if(!String.valueOf(reservs.get("USE_ST")).equals("����")&&!String.valueOf(reservs.get("USE_ST")).equals("����"))%>class="title_p"<%%> align="center"><%=AddUtil.parseDecimal(String.valueOf(reservs.get("FEE_AMT")))%></td>-->
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("����")&&!String.valueOf(reservs.get("USE_ST")).equals("����"))%>class="title_p"<%%> align="center"><%=reservs.get("BUS_NM")%></td>					
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("����")&&!String.valueOf(reservs.get("USE_ST")).equals("����"))%>class="title_p"<%%> align="center"><%=AddUtil.ChangeDate3_2(String.valueOf(reservs.get("REG_DT")))%></td>										
        			<td <%if(!String.valueOf(reservs.get("USE_ST")).equals("����")&&!String.valueOf(reservs.get("USE_ST")).equals("����"))%>class="title_pn"<%%> align="center">
					<%if(!String.valueOf(reservs.get("USE_ST")).equals("���")){%>
					<a class=index1 href="javascript:MM_openBrWindow('car_scd_add.jsp?c_id=<%=c_id%>&s_cd=<%=reservs.get("RENT_S_CD")%>&car_no=<%=res.get("CAR_NO")%>','ImgAdd','scrollbars=yes,status=yes,resizable=yes,width=620,height=600,left=50, top=50')"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
					<%}else{%>-<%}%>
					</td>			
                </tr>
              <%		}
      			}else{%>
                <tr> 
                    <td colspan='10' align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
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
    		<td><iframe src="/acar/res_search/calendar_s.jsp?c_id=<%=c_id%>" name="inner_s" width="300" height="290" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
        	</iframe></td>
    		<td><iframe src="/acar/res_search/calendar_e.jsp?c_id=<%=c_id%>" name="inner_e" width="300" height="290" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
        	</iframe></td>
  		  </tr>
		</table>
	  </td>
    </tr>
	-->	
</table>
<input type='hidden' name='use_cnt' value='<%=use_cnt%>'>  
</form>
</body>
</html>
