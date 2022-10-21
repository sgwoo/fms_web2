<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.stat_bus.*, acar.estimate_mng.*, acar.user_mng.*"%>
<jsp:useBean id="cmp_db" scope="page" class="acar.stat_bus.CampaignDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp"%>
<%@ include file="/acar/access_log.jsp" %>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();


	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw"); 	//����
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");	//�α���-ID
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");	//�α���-������
	
	
	String save_dt 		= request.getParameter("save_dt")	==null?"":request.getParameter("save_dt");
	
	
	//����
	if(auth_rw.equals(""))	auth_rw = rs_db.getXmlAuthRw(user_id, "09", "08", "23");
	
	
	//��������
	if(save_dt.equals(""))	save_dt = ad_db.getMaxSaveDt("stat_bus_cmp_v19");
	
	
	String reg_dt		= "";
	int    sum_amt 		= 0;
	float sum_c_cnt 	= 0.0f;
	float sum_cr_cnt	= 0.0f;
	float sum_r_cr_cnt	= 0.0f;
	float sum_c_cost_cnt	= 0.0f;
	float sum_c_tot_cnt	= 0.0f;
	float sum_cmp_discnt_per= 0.0f;
	float sum_org_dalsung	= 0.0f;
	String avg_dalsung 	= "";
	float avg_cnt 		= 0.0f;
	String v_year		= "";
	String v_tm		= "";
	
	String avg_car_cnt	= "";
	
	
	Vector vt = cmp_db.getCampaignList_2019_05_sc(save_dt, "2");
	
	
	//����Ͻ�
	if(vt.size()>0){
		for(int i=0; i<1; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			reg_dt 	= (String)ht.get("REG_DT");
			v_year 	= (String)ht.get("YEAR");
			v_tm 	= (String)ht.get("TM");
		}
	}
	
	if(v_year.equals("")) v_year = "2019";
	if(v_tm.equals("")) v_tm = "02";
	
	
	//����ķ���κ��� : campaign_var ���̺�
	Hashtable ht3 = cmp_db.getCampaignVar(v_year, v_tm, "2"); //2�� ����
	
	String year 		= (String)ht3.get("YEAR");
	String tm 		= (String)ht3.get("TM");
	String cs_dt 		= (String)ht3.get("CS_DT");
	String ce_dt 		= (String)ht3.get("CE_DT");
	String bs_dt 		= (String)ht3.get("BS_DT");
	String be_dt 		= (String)ht3.get("BE_DT");
	int up_per 		= AddUtil.parseInt((String)ht3.get("UP_PER"));
	int down_per 		= AddUtil.parseInt((String)ht3.get("DOWN_PER"));
	int amt_per 		= AddUtil.parseInt((String)ht3.get("AMT_PER"));
	int car_amt 		= AddUtil.parseInt((String)ht3.get("CAR_AMT"));	
	int max_dalsung 	= AddUtil.parseInt((String)ht3.get("MAX_DALSUNG"));
	int min_dalsung 	= AddUtil.parseInt((String)ht3.get("MIN_DALSUNG"));
	int ga 			= AddUtil.parseInt((String)ht3.get("GA"));
	int new_ga 		= AddUtil.parseInt((String)ht3.get("NEW_GA"));
	String ns_dt1		= (String)ht3.get("NS_DT1");
	String ns_dt2		= (String)ht3.get("NS_DT2");
	String ns_dt3		= (String)ht3.get("NS_DT3");
	String ns_dt4		= (String)ht3.get("NS_DT4");
	String ne_dt1		= (String)ht3.get("NE_DT1");
	String ne_dt2		= (String)ht3.get("NE_DT2");
	String ne_dt3		= (String)ht3.get("NE_DT3");
	String ne_dt4		= (String)ht3.get("NE_DT4");
	int n_cnt1		= AddUtil.parseInt((String)ht3.get("N_CNT1"));
	int n_cnt2		= AddUtil.parseInt((String)ht3.get("N_CNT2"));
	int n_cnt3		= AddUtil.parseInt((String)ht3.get("N_CNT3"));
	int n_cnt4		= AddUtil.parseInt((String)ht3.get("N_CNT4"));
	int cnt_per		= AddUtil.parseInt((String)ht3.get("CNT_PER"));
	int cost_per		= AddUtil.parseInt((String)ht3.get("COST_PER"));
	String base_end_dt1	= (String)ht3.get("BASE_END_DT1");
	String base_end_dt2	= (String)ht3.get("BASE_END_DT2");
	float new_mon_ga= AddUtil.parseFloat((String)ht3.get("NEW_MON_GA"));
	
	int not_cmp_cnt = 0;
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>����ķ����</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		

	//����Ʈȭ�麸��	
	function cmp_print(){
		window.open("campaign2019_5_print.jsp?loan_st=2&save_dt=<%=save_dt%>&auth_rw=<%=auth_rw%>","print","left=30,top=50,width=1050,height=850,scrollbars=yes");	
	}

	//���ĺ���
	function view_sik(){
		window.open("campaign2019_5_sik.jsp?loan_st=2&save_dt=<%=save_dt%>&bus_down_per=<%=down_per%>&mng_down_per=<%=down_per%>&cs_dt=<%=cs_dt%>&ce_dt=<%=ce_dt%>&bs_dt=<%=bs_dt%>&be_dt=<%=be_dt%>&bs_dt2=<%=bs_dt%>&be_dt2=<%=be_dt%>&enter_dt=<%=ns_dt1%>","sik","left=30,top=50,width=1050,height=600,scrollbars=yes");
	}

	//��������
	function updateVar(){
		var fm = document.form1;
		if(!confirm("�������� �����Ͻðڽ��ϱ�?"))	return;	
		fm.action = "campaign2019_5_Var2_iu.jsp";
		fm.target = '_blank';	
		fm.submit();
	}
	
	//������ó��
	function updateBuscmpYn(){
		var fm = document.form1;
		if(!confirm("������ó���� �����Ͻðڽ��ϱ�?"))	return;	
		fm.action = "campaign_yn_a.jsp";
		//fm.target = '_blank';
		fm.target = 'i_no';	
		fm.submit();	
	}
//-->
</script>
</head>

<body>
<form name="form1" method="post" action="/acar/stat_month/campaign2019_5_sc2.jsp">
<input type="hidden" name="auth_rw" 	value="<%= auth_rw %>">
<input type="hidden" name="user_id" 	value="<%= user_id %>">
<input type="hidden" name="br_id" 	value="<%= br_id %>">
<input type="hidden" name="year" 	value="<%= year %>">
<input type="hidden" name="tm" 		value="<%= tm %>">
<input type="hidden" name="vt_size" 	value="<%= vt.size() %>">
<input type="hidden" name="from_page" 	value="/acar/stat_month/campaign2019_5_sc2.jsp">
<input type="hidden" name="o_cs_dt" 	value="<%=cs_dt%>">
<input type="hidden" name="o_ce_dt" 	value="<%=ce_dt%>">
<input type="hidden" name="bs_dt" 	value="<%=bs_dt%>">
<input type="hidden" name="be_dt" 	value="<%=be_dt%>">

<input type="hidden" name="s_width" 	value="<%=s_width%>">
<table width="1000" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�濵���� > ķ���ΰ��� > <span class=style5>����ķ����(1�� ����)</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_campaign.gif align=absmiddle>&nbsp;
          <input type="text" name="cs_dt" size="11" value="<%= AddUtil.ChangeDate2(cs_dt) %>" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
          ~ 
          <input type="text" name="ce_dt" size="11" value="<%= AddUtil.ChangeDate2(ce_dt) %>" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
	  <%if(nm_db.getWorkAuthUser("������",user_id)){%>
	    &nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:cmp_print()' title='����Ʈ�ϱ�'><img src=../images/center/button_print.gif align=absmiddle border=0></a>
	  <%}%>
	</td>
    </tr>
</table>
<table width="1000" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td><div align="right"><img src=../images/center/arrow_gjij.gif align=absmiddle> : <%= reg_dt%> (�Ǵ޼�����)</div></td>
    </tr>
</table>
<table width="1000" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width="4%" rowspan="3" class="title">����</td>
                    <td width="7%" rowspan="3" class="title">�μ�</td>					
                    <td width="6%" rowspan="3" class="title">�����</td>
                    <td width="6%" rowspan="3" class="title">�򰡱���</td>
                    <td width="5%" rowspan="3" class="title">������</td>
                    <td colspan="5" class="title">ķ���� ����</td>
                    <td width="8%" rowspan="3" class="title">����ݾ�</td>
                    <td width="22%" rowspan="3">
        			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
        				<tr style='text-align:right'>
        				  <td class="title_p" width="50%" style='height:66; text-align:right;'>100</td>
        				  <td class="title_p" width="50%" style='text-align:right;'>200</td>
        				</tr>
        			  </table>
       			  </td>
       			  <td width="3%" rowspan="3" class="title"><% if(auth_rw.equals("6")){ %>��<br>��<br>��<%}else{%>-<%}%></td>
                </tr>
                <tr> 
                    <td colspan="2" class="title">�������</td>
                    <td width="7%" rowspan="2" class="title">����ȿ��<br>���</td>
                    <td width="7%" rowspan="2" class="title">ķ���ν���</td>
                    <td width="7%" rowspan="2" class="title">�޼���</td>
                </tr>
                <tr>
                  <td width="7%" class="title">�ѽ���</td>
                  <td width="7%" class="title">�������</td>
                </tr>
                <% if(vt.size()>0){
				for(int i=0; i<vt.size(); i++){
					Hashtable ht2 = (Hashtable)vt.elementAt(i);
					
					String dept_id 		= (String)ht2.get("DEPT_ID");
					float graph = 0;
					
					if(!String.valueOf(ht2.get("BUS_CMP_YN")).equals("N")){
						sum_cmp_discnt_per 	+= AddUtil.parseFloat((String)ht2.get("CMP_DISCNT_PER"));
						sum_c_cnt 		+= AddUtil.parseFloat((String)ht2.get("C_CNT"));
						sum_cr_cnt 		+= AddUtil.parseFloat((String)ht2.get("CR_CNT2"));
						sum_r_cr_cnt 		+= AddUtil.parseFloat((String)ht2.get("CR_CNT"));
						sum_amt 		+= AddUtil.parseInt((String)ht2.get("AMT2"));
						sum_c_cost_cnt		+= AddUtil.parseFloat((String)ht2.get("ORG_C_COST_CNT"));
						sum_c_tot_cnt		+= AddUtil.parseFloat((String)ht2.get("C_TOT_CNT"));
						sum_org_dalsung		+= AddUtil.parseFloat((String)ht2.get("ORG_DALSUNG"));
						if(i==0 || avg_dalsung.equals("")){
							avg_dalsung 	= (String)ht2.get("AVG_DALSUNG");
							avg_car_cnt     = (String)ht2.get("AVG_CAR_CNT");
						}
						avg_cnt++;	
						
						graph = AddUtil.parseFloat((String)ht2.get("ORG_DALSUNG"))*150/100;					
					}
										
					String loan_st_nm 	= (String)ht2.get("LOAN_ST_NM");
					String u_enter_dt 	= (String)ht2.get("ENTER_DT");
					
					if(graph >300)							graph 		= 300;
					if(AddUtil.parseInt(u_enter_dt) >= AddUtil.parseInt(ns_dt1)) 	loan_st_nm 	= "����";
					if(loan_st_nm.equals("2��"))					loan_st_nm 	= "<font color=red>2��</font>";
					
					if(String.valueOf(ht2.get("BUS_CMP_YN")).equals("N")){
						not_cmp_cnt++;
					}					
                %>
                <tr> 
                    <td align="center"><%= i+1 %></td>
                    <td align="center"><%= ht2.get("NM_CD") %></td>					
                    <td align="center"><%= ht2.get("USER_NM") %></td>
                    <td align="right"><%= ht2.get("CMP_DISCNT_PER") %></td>
                    <td align="right"><%= ht2.get("GA") %></td>
                    <td align="right"><%= ht2.get("C_CNT") %><a href="javascript:MM_openBrWindow('campaign2019_5_list_id.jsp?user_nm=<%= ht2.get("USER_NM") %>&bus_id=<%= ht2.get("USER_ID") %>&cs_dt=<%= AddUtil.ChangeDate2(cs_dt) %>&ce_dt=<%= AddUtil.ChangeDate2(ce_dt) %>&bs_dt=<%= bs_dt %>&be_dt=<%= be_dt %>','list_id','scrollbars=yes,status=no,resizable=yes,width=1500,height=860,top=50,left=50')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a></td>
                    <td align="right"><%= ht2.get("CR_CNT2") %></td>
                    <td align="right"><%= ht2.get("C_COST_CNT") %><a href="javascript:MM_openBrWindow('campaign2019_5_list_id_cost.jsp?save_dt=<%=save_dt%>&user_nm=<%= ht2.get("USER_NM") %>&bus_id=<%= ht2.get("USER_ID") %>&cs_dt=<%= AddUtil.ChangeDate2(cs_dt) %>&ce_dt=<%= AddUtil.ChangeDate2(ce_dt) %>&bs_dt=<%= bs_dt %>&be_dt=<%= be_dt %>','list_id','scrollbars=yes,status=no,resizable=yes,width=1500,height=860,top=50,left=50')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a></td>
                    <td align="right"><%= ht2.get("C_TOT_CNT") %></td>
                    <td align="right"><%= ht2.get("ORG_DALSUNG") %></td>
                    <td align="right"><%= AddUtil.parseDecimal((String)ht2.get("AMT2")) %></td>
                    <td align=""><img src=../../images/result1.gif width=<%= graph %> height=10><%if(String.valueOf(ht2.get("BUS_CMP_YN")).equals("N")){%>������<%}%></td>
                    <td align="center"><% if(auth_rw.equals("6")){ %><input type="checkbox" name="bus_cmp_yn<%=i%>" value="N" <% if(String.valueOf(ht2.get("BUS_CMP_YN")).equals("N")){%>checked<%}%>><input type="hidden" name="bus_cmp_user_id" 	value="<%= ht2.get("USER_ID") %>"><%}%></td>
                </tr>
                <% 		}
		  }%>
                <tr> 
                    <td class="title" colspan=3>�հ�</td>                             
                    <td class="title" style='text-align:right'><% if(auth_rw.equals("6")){ %><%= AddUtil.parseFloatCipher(sum_cmp_discnt_per,2) %><% } %></td>
                    <td class="title" style='text-align:right'></td>
                    <td class="title" style='text-align:right'><%= Math.round(sum_c_cnt*1000)/1000f %></td>
                    <td class="title" style='text-align:right'><%= Math.round(sum_cr_cnt*1000)/1000f %></td>
                    <td class="title" style='text-align:right'><%= Math.round(sum_c_cost_cnt*1000)/1000f %></td>
                    <td class="title" style='text-align:right'><%= Math.round(sum_c_tot_cnt*1000)/1000f %></td>
                    <td class="title" style='text-align:right'></td>
                    <td class="title" style='text-align:right'><%= AddUtil.parseDecimal(sum_amt) %></td>
                    <td class="title" style='text-align:left'>&nbsp;<%if(not_cmp_cnt > 0){%>������ ����<%}%></td>
                    <td class="title" style='text-align:right'></td>
                </tr>
                <tr> 
                    <td class="title" colspan=3>���</td>                             
                    <td class="title" style='text-align:right'><% if(auth_rw.equals("6")){ %><%= AddUtil.parseFloatCipher(sum_cmp_discnt_per/avg_cnt,2) %><% } %></td>
                    <td class="title" style='text-align:right'></td>
                    <td class="title" style='text-align:right'><%= AddUtil.parseFloatCipher(sum_c_cnt/avg_cnt,2) %></td>
                    <td class="title" style='text-align:right'><%= AddUtil.parseFloatCipher(sum_cr_cnt/avg_cnt,2) %></td>
                    <td class="title" style='text-align:right'><%= AddUtil.parseFloatCipher(sum_c_cost_cnt/avg_cnt,2) %></td>
                    <td class="title" style='text-align:right'><%= AddUtil.parseFloatCipher(sum_c_tot_cnt/avg_cnt,2) %></td>
                    <td class="title" style='text-align:right'><%= avg_dalsung %></td>
                    <td class="title" style='text-align:right'><%= AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(sum_amt/avg_cnt))) %></td>
                    <td class="title" style='text-align:left'>&nbsp;<%if(not_cmp_cnt > 0){%>������ ����<!-- &nbsp;(�Ǵ޼��� ���:<%= AddUtil.parseFloatCipher(sum_org_dalsung/avg_cnt,2) %>) --><%}%></td>
                    <td class="title" style='text-align:right'></td>
                </tr>                 
          </table>
  	    </td>
    </tr>
</table>
  <% if(auth_rw.equals("6")){ %>
<table width="1000" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td align="right"><input type="button" class="button" id="all_act_bus_cmp_yn" value='������ ó��' onclick="javascript:updateBuscmpYn();"></td>
    </tr>
</table>  
  <% }	%>
<table width="1000" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
          <p><font color="#999999">
            <br>
            �� ķ���� ������� ������� = ���� ��������հ� * (�ѽ����μ����հ�/��������μ����հ� (<%= AddUtil.parseFloatCipher(avg_car_cnt,6) %>))  �� ��������μ����հ� <%= Math.round(sum_r_cr_cnt*1000)/1000f %> (�ѽ�������������)
            <br>
            �� �⺻ �򰡱��� : ķ���� ������ ���� �Ի� 36���� �̻��� ���� ��ü�� ���� ķ���� ���� ���
            <br>
            �� ������ : ķ���� ������ ���� �Ի� 36���� �̸��ڴ� 1������ �������� �Ի簳������ �ݿ�
            <br>
            �� �򰡱��� : �⺻�򰡱��ؿ� ������ �ݿ�
            <br>
            �� ��ȿ���� : �뷮������ ��� 5�� �ʰ� ���� 50%�� �����ϰ� ���Ͼ�ü�� ���� �ִ� 10����� ��������.
            <br>
	    �� ķ���ν��� : (ķ���αⰣ ������� ��ȿ������� * �����������ġ) + (ķ���αⰣ ����ȿ����� ��ȿ������� * ����ȿ���������ġ)
	    <br>
	    �� �޼��� : ķ���ν��� / �򰡱���
	  </font></p>
        </td>
    </tr>
</table>
  <br>
  <% if(auth_rw.equals("6")){ %>
<table width="1000" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>1. ���رݾ�</td>
        <td>: 
        <input type="text" name="amt" size="11" value="" class=whitenum >
		�� =
		<input type="text" name="car_amt" size="11" value="<%= AddUtil.parseDecimal(car_amt) %>" class=num onBlur='javascript:getR_cnt(); this.value=parseDecimal(this.value)'>
		*
		<input type="text" name="total_car" size="5" value="" class=whitenum >
		(ķ���ν��� �հ�)
		</td>
    </tr>
    <tr> 
        <td>2. �������ġ </td>
        <td>: �������
        <input type="text" name="cnt_per" size="4" value="<%= cnt_per %>" class=num >
		%, ����ȿ�����
		<input type="text" name="cost_per" size="4" value="<%= cost_per %>" class=num >
		%
		</td>		
    </tr>	
    <tr> 
        <td>3. ��ǥ����ġ</td>
        <td>: 2��(����)
		<input type="text" name="ga" size="3" value="<%= ga %>" class=num >
		% 
		���Ի�� 1���� ������ <input type="text" name="new_mon_ga" size="3" value="<%= new_mon_ga %>" class=num >
		% �ݿ�
		</td>
    </tr>
    <tr> 
        <td>4. ����ݾ� ������</td>
        <td>: 2��(����)
		<input type="text" name="amt_per" size="3" value="<%= amt_per %>" class=num >
		%</td>
    </tr>
 	
</table>
<table width="1000" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td align="right"><input type="button" class="button" id="updateCmpVar" value='���� ����' onclick="javascript:updateVar();"></td>
    </tr>
</table>  

  <% }else{ %>
<table width="1000" border="0" cellspacing="0" cellpadding="0">
    <tr>		
        <td>&nbsp;</td>
    </tr>
</table>
  <% } %>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<% if(auth_rw.equals("6")){ %>
<script language="javascript">
<!--	
	document.form1.total_car.value 	= "<%= AddUtil.parseFloatCipher(sum_c_tot_cnt,2) %>";	
	document.form1.amt.value 	= "<%= AddUtil.parseDecimal(Math.round(car_amt*sum_c_tot_cnt/1000)*1000) %>";
//-->
</script>
<% } %>