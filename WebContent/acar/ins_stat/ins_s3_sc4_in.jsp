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
	int num =0;
	
	if(!st_dt.equals("")) 	st_dt = AddUtil.replace(st_dt, "-", "");
	if(!end_dt.equals("")) 	end_dt = AddUtil.replace(end_dt, "-", "");
	
	InsDatabase ai_db = InsDatabase.getInstance();
	
	//출력년월
	Vector yms = ai_db.getInsStatList3_in3_sub1(br_id, gubun1, gubun2, gubun3, gubun4, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc, s_st);
	int ym_size = yms.size();
	
//	Vector inss = ai_db.getInsStatList3_in3(br_id, gubun1, gubun2, gubun3, gubun4, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc);
//	int ins_size = inss.size();	
	
	int su1[] = new int[ym_size];
	int su2[] = new int[ym_size];
	int su3[] = new int[ym_size];
	int su4[] = new int[ym_size];
	int su5[] = new int[ym_size];
	long amt1[] = new long[ym_size];
	long amt2[] = new long[ym_size];
	long amt3[] = new long[ym_size];
	long amt4[] = new long[ym_size];
	long amt5[] = new long[ym_size];
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
<input type='hidden' name='size' value='<%=ym_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <%if(ym_size > 0){%>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%for (int i = 0 ; i < ym_size ; i++){
    		  		Hashtable pym = (Hashtable)yms.elementAt(i);
    				InsStatBean ins1 = ai_db.getInsStatList3_in4_bean(String.valueOf(pym.get("PAY_DT")), "신규", br_id, gubun1, gubun2, gubun3, gubun4, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc, s_st);
    				InsStatBean ins2 = ai_db.getInsStatList3_in4_bean(String.valueOf(pym.get("PAY_DT")), "갱신", br_id, gubun1, gubun2, gubun3, gubun4, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc, s_st);
    				InsStatBean ins3 = ai_db.getInsStatList3_in4_bean(String.valueOf(pym.get("PAY_DT")), "분납", br_id, gubun1, gubun2, gubun3, gubun4, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc, s_st);
    				su1[i] = ins1.getSu1()+ins2.getSu1()+ins3.getSu1();
    				su2[i] = ins1.getSu2()+ins2.getSu2()+ins3.getSu2();
    				su3[i] = ins1.getSu3()+ins2.getSu3()+ins3.getSu3();
    				su4[i] = ins1.getSu4()+ins2.getSu4()+ins3.getSu4();
    				su5[i] = ins1.getSu5()+ins2.getSu5()+ins3.getSu5();
    				amt1[i] = ins1.getAmt1()+ins2.getAmt1()+ins3.getAmt1();
    				amt2[i] = ins1.getAmt2()+ins2.getAmt2()+ins3.getAmt2();
    				amt3[i] = ins1.getAmt3()+ins2.getAmt3()+ins3.getAmt3();
    				amt4[i] = ins1.getAmt4()+ins2.getAmt4()+ins3.getAmt4();
    				amt5[i] = ins1.getAmt5()+ins2.getAmt5()+ins3.getAmt5();
    				%>
                <tr> 
                    <td rowspan="4" align='center' width=9%><%=String.valueOf(pym.get("PAY_DT")).substring(4,6)%>월<a href="javascript:parent.AccidentDisp('<%//=ym[i]%>')" onMouseOver="window.status=''; return true"></a></td>
                    <td align="center" width=9%>신규</td>
                    <td align="center" width=7%> 
                      <input type="text" name="su1" value="<%=ins1.getSu1()%>" size="3" class="whitenum">
                    </td>
                    <td align="center" width=9%> 
                      <input type="text" name="amt1" size="10" value="<%=Util.parseDecimal(ins1.getAmt1())%>" class="whitenum">
                    </td>
                    <td align="center" width=7%> 
                      <input type="text" name="su2" value="<%=ins1.getSu2()%>" size="3" class="whitenum">
                    </td>
                    <td align="center" width=9%> 
                      <input type="text" name="amt2" size="10" value="<%=Util.parseDecimal(ins1.getAmt2())%>" class="whitenum">
                      </td>
                    <td align="center" width=7%> 
                      <input type="text" name="su3" value="<%=ins1.getSu3()%>" size="3" class="whitenum">
                    </td>
                    <td align="center" width=9%> 
                      <input type="text" name="amt3" size="10" value="<%=Util.parseDecimal(ins1.getAmt3())%>" class="whitenum">
                      </td>
                    <td align="center" width=7%> 
                      <input type="text" name="su4" value="<%=ins1.getSu4()%>" size="3" class="whitenum">
                    </td>
                    <td align="center" width=9%> 
                      <input type="text" name="amt4" size="10" value="<%=Util.parseDecimal(ins1.getAmt4())%>" class="whitenum">
                      </td>
                    <td align="center" width=7%> 
                      <input type="text" name="su5" value="<%=ins1.getSu5()%>" size="3" class="whitenum">
                    </td>
                    <td align="center" width=9%> 
                      <input type="text" name="amt5" size="10" value="<%=Util.parseDecimal(ins1.getAmt5())%>" class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td align="center">갱신</td>
                    <td align="center"> 
                      <input type="text" name="su1" value="<%=ins2.getSu1()%>" size="3" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="amt1" size="10" value="<%=Util.parseDecimal(ins2.getAmt1())%>" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="su2" value="<%=ins2.getSu2()%>" size="3" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="amt2" size="10" value="<%=Util.parseDecimal(ins2.getAmt2())%>" class="whitenum">
                      </td>
                    <td align="center"> 
                      <input type="text" name="su3" value="<%=ins2.getSu3()%>" size="3" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="amt3" size="10" value="<%=Util.parseDecimal(ins2.getAmt3())%>" class="whitenum">
                      </td>
                    <td align="center"> 
                      <input type="text" name="su4" value="<%=ins2.getSu4()%>" size="3" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="amt4" size="10" value="<%=Util.parseDecimal(ins2.getAmt4())%>" class="whitenum">
                      </td>
                    <td align="center"> 
                      <input type="text" name="su5" value="<%=ins2.getSu5()%>" size="3" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="amt5" size="10" value="<%=Util.parseDecimal(ins2.getAmt5())%>" class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td align="center">분납</td>
                    <td align="center"> 
                      <input type="text" name="su1" value="<%=ins3.getSu1()%>" size="3" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="amt1" size="10" value="<%=Util.parseDecimal(ins3.getAmt1())%>" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="su2" value="<%=ins3.getSu2()%>" size="3" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="amt2" size="10" value="<%=Util.parseDecimal(ins3.getAmt2())%>" class="whitenum">
                      </td>
                    <td align="center"> 
                      <input type="text" name="su3" value="<%=ins3.getSu3()%>" size="3" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="amt3" size="10" value="<%=Util.parseDecimal(ins3.getAmt3())%>" class="whitenum">
                      </td>
                    <td align="center"> 
                      <input type="text" name="su4" value="<%=ins3.getSu4()%>" size="3" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="amt4" size="10" value="<%=Util.parseDecimal(ins3.getAmt4())%>" class="whitenum">
                      </td>
                    <td align="center"> 
                      <input type="text" name="su5" value="<%=ins3.getSu5()%>" size="3" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="amt5" size="10" value="<%=Util.parseDecimal(ins3.getAmt5())%>" class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td align="center">소계</td>
                    <td align="center"> 
                      <input type="text" name="t_su1" value="<%=su1[i]%>" size="3" class="whitenum">
                      </td>
                    <td align="center"> 
                      <input type="text" name="t_amt1" size="10" value="<%=Util.parseDecimal(amt1[i])%>" class="whitenum">
                      </td>
                    <td align="center"> 
                      <input type="text" name="t_su2" value="<%=su2[i]%>" size="3" class="whitenum">
                      </td>
                    <td align="center"> 
                      <input type="text" name="t_amt2" size="10" value="<%=Util.parseDecimal(amt2[i])%>" class="whitenum">
                      </td>
                    <td align="center"> 
                      <input type="text" name="t_su3" value="<%=su3[i]%>" size="3" class="whitenum">
                      </td>
                    <td align="center"> 
                      <input type="text" name="t_amt3" size="10" value="<%=Util.parseDecimal(amt3[i])%>" class="whitenum">
                      </td>
                    <td align="center"> 
                      <input type="text" name="t_su4" value="<%=su4[i]%>" size="3" class="whitenum">
                      </td>
                    <td align="center"> 
                      <input type="text" name="t_amt4" size="10" value="<%=Util.parseDecimal(amt4[i])%>" class="whitenum">
                      </td>
                    <td align="center"> 
                      <input type="text" name="t_su5" value="<%=su5[i]%>" size="3" class="whitenum">
                      </td>
                    <td align="center"> 
                      <input type="text" name="t_amt5" size="10" value="<%=Util.parseDecimal(amt5[i])%>" class="whitenum">
                    </td>
                </tr>
              <%	num+=3;
    		  }%>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' rowspan="4" width=9% align="center">합계</td>
                    <td class='result' width=9% align="center">신규</td>
                    <td class='result' align="center" width=7%> 
                      <input type="text" name="tot_su1" value="" size="3" class="whitenum">
                    </td>
                    <td class='result' align="center" width=9%> 
                      <input type="text" name="tot_amt1" size="10" value="" class="whitenum">
                    </td>
                    <td class='result' align="center" width=7%> 
                      <input type="text" name="tot_su2" value="" size="3" class="whitenum">
                    </td>
                    <td class='result' align="center" width=9%> 
                      <input type="text" name="tot_amt2" size="10" value="" class="whitenum">
                    </td>
                    <td class='result' align="center" width=7%> 
                      <input type="text" name="tot_su3" value="" size="3" class="whitenum">
                    </td>
                    <td class='result' align="center" width=9%> 
                      <input type="text" name="tot_amt3" size="10" value="" class="whitenum">
                    </td>
                    <td class='result' align="center" width=7%> 
                      <input type="text" name="tot_su4" value="" size="3" class="whitenum">
                    </td>
                    <td class='result' align="center" width=9%> 
                      <input type="text" name="tot_amt4" size="10" value="" class="whitenum">
                    </td>
                    <td class='result' align="center" width=7%> 
                      <input type="text" name="tot_su5" value="" size="3" class="whitenum">
                    </td>
                    <td class='result' align="center" width=9%> 
                      <input type="text" name="tot_amt5" size="10" value="" class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td class='result' align="center">갱신</td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_su1" value="" size="3" class="whitenum">
                    </td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_amt1" size="10" value="" class="whitenum">
                    </td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_su2" value="" size="3" class="whitenum">
                    </td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_amt2" size="10" value="" class="whitenum">
                    </td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_su3" value="" size="3" class="whitenum">
                    </td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_amt3" size="10" value="" class="whitenum">
                    </td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_su4" value="" size="3" class="whitenum">
                    </td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_amt4" size="10" value="" class="whitenum">
                    </td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_su5" value="" size="3" class="whitenum">
                    </td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_amt5" size="10" value="" class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td class='result' align="center">분납</td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_su1" value="" size="3" class="whitenum">
                    </td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_amt1" size="10" value="" class="whitenum">
                    </td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_su2" value="" size="3" class="whitenum">
                    </td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_amt2" size="10" value="" class="whitenum">
                    </td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_su3" value="" size="3" class="whitenum">
                    </td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_amt3" size="10" value="" class="whitenum">
                    </td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_su4" value="" size="3" class="whitenum">
                    </td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_amt4" size="10" value="" class="whitenum">
                    </td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_su5" value="" size="3" class="whitenum">
                    </td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_amt5" size="10" value="" class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td class='result' align="center">소계</td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_su1" value="" size="3" class="whitenum">
                    </td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_amt1" size="10" value="" class="whitenum">
                    </td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_su2" value="" size="3" class="whitenum">
                    </td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_amt2" size="10" value="" class="whitenum">
                    </td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_su3" value="" size="3" class="whitenum">
                    </td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_amt3" size="10" value="" class="whitenum">
                    </td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_su4" value="" size="3" class="whitenum">
                    </td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_amt4" size="10" value="" class="whitenum">
                    </td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_su5" value="" size="3" class="whitenum">
                    </td>
                    <td class='result' align="center"> 
                      <input type="text" name="tot_amt5" size="10" value="" class="whitenum">
                    </td>
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
        <td><font color="#FF3399">♧ 자차보험료적립금액</font> = 차량가격 ÷ 법인업무용 차량자차보험요율</td>
    </tr>			
</table>
</form>
<script language='javascript'>
<!--
	var fm = document.form1;	
	var size = toInt(fm.size.value);	

	for(i=0; i<size ; i++){
		for(j=0; j<3; j++){
			//신규,갱신,분납
			fm.tot_su1[j].value = toInt(fm.tot_su1[j].value) + toInt(fm.su1[3*i+j].value);
			fm.tot_su2[j].value = toInt(fm.tot_su2[j].value) + toInt(fm.su2[3*i+j].value);
			fm.tot_su3[j].value = toInt(fm.tot_su3[j].value) + toInt(fm.su3[3*i+j].value);
			fm.tot_su4[j].value = toInt(fm.tot_su4[j].value) + toInt(fm.su4[3*i+j].value);
			fm.tot_su5[j].value = toInt(fm.tot_su5[j].value) + toInt(fm.su5[3*i+j].value);
			fm.tot_amt1[j].value = parseDecimal(toInt(parseDigit(fm.tot_amt1[j].value)) + toInt(parseDigit(fm.amt1[3*i+j].value)));
			fm.tot_amt2[j].value = parseDecimal(toInt(parseDigit(fm.tot_amt2[j].value)) + toInt(parseDigit(fm.amt2[3*i+j].value)));
			fm.tot_amt3[j].value = parseDecimal(toInt(parseDigit(fm.tot_amt3[j].value)) + toInt(parseDigit(fm.amt3[3*i+j].value)));
			fm.tot_amt4[j].value = parseDecimal(toInt(parseDigit(fm.tot_amt4[j].value)) + toInt(parseDigit(fm.amt4[3*i+j].value)));
			fm.tot_amt5[j].value = parseDecimal(toInt(parseDigit(fm.tot_amt5[j].value)) + toInt(parseDigit(fm.amt5[3*i+j].value)));
		}
		//소계
		if(size > 1){
			fm.tot_su1[3].value = toInt(fm.tot_su1[3].value) + toInt(fm.t_su1[i].value);
			fm.tot_su2[3].value = toInt(fm.tot_su2[3].value) + toInt(fm.t_su2[i].value);
			fm.tot_su3[3].value = toInt(fm.tot_su3[3].value) + toInt(fm.t_su3[i].value);
			fm.tot_su4[3].value = toInt(fm.tot_su4[3].value) + toInt(fm.t_su4[i].value);
			fm.tot_su5[3].value = toInt(fm.tot_su5[3].value) + toInt(fm.t_su5[i].value);
			fm.tot_amt1[3].value = parseDecimal(toInt(parseDigit(fm.tot_amt1[3].value)) + toInt(parseDigit(fm.t_amt1[i].value)));
			fm.tot_amt2[3].value = parseDecimal(toInt(parseDigit(fm.tot_amt2[3].value)) + toInt(parseDigit(fm.t_amt2[i].value)));
			fm.tot_amt3[3].value = parseDecimal(toInt(parseDigit(fm.tot_amt3[3].value)) + toInt(parseDigit(fm.t_amt3[i].value)));
			fm.tot_amt4[3].value = parseDecimal(toInt(parseDigit(fm.tot_amt4[3].value)) + toInt(parseDigit(fm.t_amt4[i].value)));
			fm.tot_amt5[3].value = parseDecimal(toInt(parseDigit(fm.tot_amt5[3].value)) + toInt(parseDigit(fm.t_amt5[i].value)));
		}else{
			fm.tot_su1[3].value = toInt(fm.tot_su1[3].value) + toInt(fm.t_su1.value);
			fm.tot_su2[3].value = toInt(fm.tot_su2[3].value) + toInt(fm.t_su2.value);
			fm.tot_su3[3].value = toInt(fm.tot_su3[3].value) + toInt(fm.t_su3.value);
			fm.tot_su4[3].value = toInt(fm.tot_su4[3].value) + toInt(fm.t_su4.value);
			fm.tot_su5[3].value = toInt(fm.tot_su5[3].value) + toInt(fm.t_su5.value);
			fm.tot_amt1[3].value = parseDecimal(toInt(parseDigit(fm.tot_amt1[3].value)) + toInt(parseDigit(fm.t_amt1.value)));
			fm.tot_amt2[3].value = parseDecimal(toInt(parseDigit(fm.tot_amt2[3].value)) + toInt(parseDigit(fm.t_amt2.value)));
			fm.tot_amt3[3].value = parseDecimal(toInt(parseDigit(fm.tot_amt3[3].value)) + toInt(parseDigit(fm.t_amt3.value)));
			fm.tot_amt4[3].value = parseDecimal(toInt(parseDigit(fm.tot_amt4[3].value)) + toInt(parseDigit(fm.t_amt4.value)));
			fm.tot_amt5[3].value = parseDecimal(toInt(parseDigit(fm.tot_amt5[3].value)) + toInt(parseDigit(fm.t_amt5.value)));		
		}		
	}
//-->
</script>
</body>
</html>
