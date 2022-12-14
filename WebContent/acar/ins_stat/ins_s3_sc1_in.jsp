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
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	int size1 = 0;
	
	if(!st_dt.equals("")) 	st_dt = AddUtil.replace(st_dt, "-", "");
	if(!end_dt.equals("")) 	end_dt = AddUtil.replace(end_dt, "-", "");
	
	InsDatabase ai_db = InsDatabase.getInstance();
	
	Vector inss = ai_db.getInsStatList3_in1(br_id, gubun1, gubun2, gubun3, gubun4, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc, s_st);
	int ins_size = inss.size();	
	
	String ym[] = new String[ins_size];
	String st[] = new String[ins_size];
	int su1[] = new int[ins_size];
	int su2[] = new int[ins_size];
	int su3[] = new int[ins_size];
	int su4[] = new int[ins_size];
	int su5[] = new int[ins_size];
	int total_su[] = new int[10];
	long amt1[] = new long[ins_size];
	long amt2[] = new long[ins_size];
	long amt3[] = new long[ins_size];
	long amt4[] = new long[ins_size];
	long amt5[] = new long[ins_size];
	long total_amt[] = new long[10];
	
	for (int i = 0 ; i < ins_size ; i++){
		Hashtable ins = (Hashtable)inss.elementAt(i);
		ym[i] = String.valueOf(ins.get("PAY_DT"));
		st[i] = String.valueOf(ins.get("CAR_ST"));
		su1[i] = Integer.parseInt(String.valueOf(ins.get("SU1")));
		su2[i] = Integer.parseInt(String.valueOf(ins.get("SU2")));
		su3[i] = Integer.parseInt(String.valueOf(ins.get("SU3")));
		su4[i] = Integer.parseInt(String.valueOf(ins.get("SU4")));
		su5[i] = Integer.parseInt(String.valueOf(ins.get("SU5")));
		amt1[i] = Long.parseLong(String.valueOf(ins.get("AMT1")));
		amt2[i] = Long.parseLong(String.valueOf(ins.get("AMT2")));
		amt3[i] = Long.parseLong(String.valueOf(ins.get("AMT3")));
		amt4[i] = Long.parseLong(String.valueOf(ins.get("AMT4")));
		amt5[i] = Long.parseLong(String.valueOf(ins.get("AMT5")));
		//합계
		if(st[i].equals("렌트")){
			total_su[0] = total_su[0] + su1[i];
			total_su[1] = total_su[1] + su2[i];
			total_su[2] = total_su[2] + su3[i];
			total_su[3] = total_su[3] + su4[i];
			total_su[4] = total_su[4] + su5[i];
			total_amt[0] = total_amt[0] + amt1[i];
			total_amt[1] = total_amt[1] + amt2[i];
			total_amt[2] = total_amt[2] + amt3[i];
			total_amt[3] = total_amt[3] + amt4[i];
			total_amt[4] = total_amt[4] + amt5[i];
		}else{
			total_su[5] = total_su[5] + su1[i];
			total_su[6] = total_su[6] + su2[i];
			total_su[7] = total_su[7] + su3[i];
			total_su[8] = total_su[8] + su4[i];
			total_su[9] = total_su[9] + su5[i];
			total_amt[5] = total_amt[5] + amt1[i];
			total_amt[6] = total_amt[6] + amt2[i];
			total_amt[7] = total_amt[7] + amt3[i];
			total_amt[8] = total_amt[8] + amt4[i];
			total_amt[9] = total_amt[9] + amt5[i];
		}
	}
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
    <%if(ins_size > 0){%>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%for (int i = 0 ; i < ins_size ; i++){
    					Hashtable ins = (Hashtable)inss.elementAt(i);%>
                <tr>
    		  <%if(i == 0){//처음%> 
    		  <%	if(ym[i].equals(ym[i+1])){%> 
                    <td width='9%' align='center' rowspan="2"><%=AddUtil.ChangeDate2(ym[i])%>월<a href="javascript:parent.AccidentDisp('<%=ym[i]%>')" onMouseOver="window.status=''; return true"></a></td>
    		  <%	}else{%>
                    <td width='9%' align='center'><%=AddUtil.ChangeDate2(ym[i])%>월<a href="javascript:parent.AccidentDisp('<%=ym[i]%>')" onMouseOver="window.status=''; return true"></a></td>		  
    		  <%	}%>		  		  		  		  
    		  <%}else if(i+1 == ins_size){//마지막%> 
    		  <%	if(ym[i].equals(ym[i-1])){%> 
    		  <%	}else{%>
                    <td width='9%' align='center'><%=AddUtil.ChangeDate2(ym[i])%>월<a href="javascript:parent.AccidentDisp('<%=ym[i]%>')" onMouseOver="window.status=''; return true"></a></td>		  
    		  <%	}%>		  		  		  		  	  
    		  <%}else{//중간%> 
    		  <%	if(ym[i].equals(ym[i-1])){%> 
    		  <%	}else if(ym[i].equals(ym[i+1])){%> 		  
                    <td width='9%' align='center' rowspan="2"><%=AddUtil.ChangeDate2(ym[i])%>월<a href="javascript:parent.AccidentDisp('<%=ym[i]%>')" onMouseOver="window.status=''; return true"></a></td>
    		  <%	}else{%>
                    <td width='9%' align='center'><%=AddUtil.ChangeDate2(ym[i])%>월<a href="javascript:parent.AccidentDisp('<%=ym[i]%>')" onMouseOver="window.status=''; return true"></a></td>		  
    		  <%	}%>		  		  		  		  		  
    		  <%}%> 		  
                    <td align="center" width='9%'><%=st[i]%></td>
                    <td align="center" width='6%'><%=su1[i]%></td>
                    <td align="right" width='10%'><%=Util.parseDecimal(amt1[i])%>&nbsp;&nbsp;</td>
                    <td align="center" width='6%'><%=su2[i]%></td>
                    <td align="right" width='10%'><%=Util.parseDecimal(amt2[i])%>&nbsp;&nbsp;</td>
                    <td align="center" width='6%'><%=su3[i]%></td>
                    <td align="right" width='10%'><%=Util.parseDecimal(amt3[i])%>&nbsp;&nbsp;</td>
                    <td align="center" width='6%'><%=su4[i]%></td>
                    <td align="right" width='10%'><%=Util.parseDecimal(amt4[i])%>&nbsp;&nbsp;</td>
                    <td align="center" width='6%'><%=su5[i]%></td>
                    <td align="right" width='10%'><%=Util.parseDecimal(amt5[i])%>&nbsp;&nbsp;</td>
                </tr>
              <%}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' rowspan="2" width='9%' align="center">합계</td>
                    <td class='title' width='9%' align="center">렌트</td>
                    <td class='title' width='6%' align="center"><%=total_su[0]%></td>
                    <td class='title' width='10%' style='text-align:right'><%=Util.parseDecimal(total_amt[0])%>&nbsp;&nbsp;</td>
                    <td class='title' width='6%' align="center"><%=total_su[1]%></td>
                    <td class='title' width='10%' style='text-align:right'><%=Util.parseDecimal(total_amt[1])%>&nbsp;&nbsp;</td>
                    <td class='title' width='6%' align="center"><%=total_su[2]%></td>
                    <td class='title' width='10%' style='text-align:right'><%=Util.parseDecimal(total_amt[2])%>&nbsp;&nbsp;</td>
                    <td class='title' width='6%' align="center"><%=total_su[3]%></td>
                    <td class='title' width='10%' style='text-align:right'><%=Util.parseDecimal(total_amt[3])%>&nbsp;&nbsp;</td>
                    <td class='title' width='6%' align="center"><%=total_su[4]%></td>
                    <td class='title' width='10%' style='text-align:right'><%=Util.parseDecimal(total_amt[4])%>&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title' align="center">리스</td>
                    <td class='title' align="center"><%=total_su[5]%></td>
                    <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt[5])%>&nbsp;&nbsp;</td>
                    <td class='title' align="center"><%=total_su[6]%></td>
                    <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt[6])%>&nbsp;&nbsp;</td>
                    <td class='title' align="center"><%=total_su[7]%></td>
                    <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt[7])%>&nbsp;&nbsp;</td>
                    <td class='title' align="center"><%=total_su[8]%></td>
                    <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt[8])%>&nbsp;&nbsp;</td>
                    <td class='title' align="center"><%=total_su[9]%></td>
                    <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt[9])%>&nbsp;&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>	
    <%}else{%>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align="center">등록된 데이타가 없습니다.</td>
                </tr>
            </table>
        </td>
    </tr>	
    <%}%>
    <tr>
        <td class=h></td>
    </tr>	
    <tr> 
        <td>&nbsp;&nbsp;<font color="#FF3399">♧ 자차보험료적립금액</font> = 차량가격 ÷ 법인업무용 차량자차보험요율</td>
    </tr>			
</table>
</form>
</body>
</html>
