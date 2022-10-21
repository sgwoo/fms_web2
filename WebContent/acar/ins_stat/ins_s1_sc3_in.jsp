<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function AccidentDisp(m_id, l_cd, c_id, accid_id, accid_st){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.accid_id.value = accid_id;		
		fm.accid_st.value = accid_st;				
		fm.cmd.value = "u";	
		fm.target = ' d_content';	
		fm.action = '../accid_mng/accid_u_frame.jsp';			
		fm.submit();
	}
	
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=720, height=550, scrollbars=yes");
	}
	
	//하단메뉴 이동
	function sub_in(car_comp_id, tot_su){
		var fm = document.form1;
		fm.car_comp_id.value = car_comp_id;
		fm.tot_su.value = tot_su;
		fm.action="ins_s1_sc1_in.jsp";
		fm.target="i_in";		
		fm.submit();	
	}	
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"1":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	int size1 = 0;
	
	if(!st_dt.equals("")) 	st_dt = AddUtil.replace(st_dt, "-", "");
	if(!end_dt.equals("")) 	end_dt = AddUtil.replace(end_dt, "-", "");
	
	InsDatabase ai_db = InsDatabase.getInstance();
	
	Vector inss = ai_db.getInsStatList_in3(br_id, brch_id, st_dt, end_dt, gubun1, gubun2);
	int ins_size = inss.size();	
	
	long total_amt = 0;
%>
<form name='form1' action='../ins_mng/ins_u_frame.jsp' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun0' value='<%=gubun0%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='gubun7' value='<%=gubun7%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='accid_id' value=''>
<input type='hidden' name='accid_st' value=''>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='car_comp_id' value=''>
<input type='hidden' name='tot_su' value=''>
<input type='hidden' name='go_url' value='../ins_stat/ins_s1_frame.jsp'>
<input type='hidden' name='size' value='<%=ins_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%if(ins_size > 0){%>
              <%	for (int i = 0 ; i < ins_size ; i++){
    					Hashtable ins = (Hashtable)inss.elementAt(i);%>
                <tr> 
                    <td align="center" width='4%'><%=i+1%></td>
                    <td align="center" width='7%'><%=ins.get("CAR_ST")%></td>
                    <td align="center" width='9%'><a href="javascript:parent.insDisp('<%=ins.get("RENT_MNG_ID")%>', '<%=ins.get("RENT_L_CD")%>', '<%=ins.get("CAR_MNG_ID")%>', '<%=ins.get("INS_ST")%>')" onMouseOver="window.status=''; return true"><%=ins.get("CAR_NO")%></a></td>
                   	<td align="center" width='5%'><%=ins.get("JG_CODE")%></td>
                    <td align="center" width='14%'><span title='<%=ins.get("CAR_NM")%> <%=ins.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(ins.get("CAR_NM")), 9)%></span></td>
                    <td align="center" width='9%'><%=ins.get("INIT_REG_DT")%></td>
                    <td align="center" width='8%'><%=ins.get("INS_COM_NM")%></td>
                    <td align="center" width='9%'><%=AddUtil.ChangeDate2(String.valueOf(ins.get("CH_DT")))%></td>
                    <td width='11%'>&nbsp;<span title='<%=ins.get("CH_ITEM")%>'><%=Util.subData(String.valueOf(ins.get("CH_ITEM")), 6)%></span></td>
                    <td width='13%'>&nbsp;<span title='<%=ins.get("CH_AFTER")%>'><%=Util.subData(String.valueOf(ins.get("CH_AFTER")), 12)%></span></td>
                    <td align="right" width='10%'><%=Util.parseDecimal(String.valueOf(ins.get("CH_AMT")))%>원&nbsp;</td>
                </tr>
              <%		total_amt = total_amt + Long.parseLong(String.valueOf(ins.get("CH_AMT")));
    			  }%>
                <tr> 
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>계</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt)%>원&nbsp;</td>
                </tr>
              <%}else{%>
                <tr align="center"> 
                    <td colspan="11">등록된 데이타가 없습니다.</td>
                </tr>
              <%}%>
            </table>
        </td>
    </tr>
</table>
</form>
<script language='javascript'>
<!--
	parent.document.form1.total.value = document.form1.size.value;
//-->
</script>
</body>
</html>
