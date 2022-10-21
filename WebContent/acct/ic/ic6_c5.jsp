<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acct.*"%>
<%@ include file="/acct/cookies.jsp" %>
<jsp:useBean id="at_db" scope="page" class="acct.AcctDatabase"/>
<%	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?"":request.getParameter("br_id");

	String st_dt 	= request.getParameter("st_dt")	 ==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt") ==null?"":request.getParameter("end_dt");
	String s_cnt 	= request.getParameter("s_cnt")  ==null?"":request.getParameter("s_cnt");
	
	//마감변수
	String var1 = at_db.getAcctVarCase("acct_var1");
	String var2 = at_db.getAcctVarCase("acct_var2");
	String var3 = at_db.getAcctVarCase("acct_var3");

	Vector vt = new Vector();
	int vt_size = 0;
	int chk_size = 0;	
		
	if(st_dt.equals("") && end_dt.equals("") && s_cnt.equals("")){	
		st_dt 	= var1;
		end_dt 	= var2;
		s_cnt 	= var3;	
		chk_size = 0;
			
	}else{
		vt = at_db.getAcct_in_search(st_dt, end_dt, s_cnt, "ic6_c5");
		vt_size = vt.size();
		chk_size = vt.size();	
		s_cnt  = Integer.toString(vt.size());
	}
	if ( chk_size < 1) s_cnt = var3;
	
	vt_size = AddUtil.parseDigit(s_cnt);	
	
	int exception_cnt = 0;
			
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/acct/include/table_t.css"></link>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function Search()
	{
		var fm = document.form1;
		//if(fm.st_dt.value == '')	{ alert('시작일을 입력하십시오.'); 	fm.st_dt.focus(); 	return; }	
		//if(fm.end_dt.value == '')	{ alert('종료일을 입력하십시오.'); 	fm.end_dt.focus(); 	return; }
		if(fm.s_cnt.value == '')	{ alert('샘플수를 입력하십시오.'); 	fm.s_cnt.focus(); 	return; }
		
		fm.target = "_self";
		fm.action = "ic6_c5.jsp";	
		fm.submit();
	}
	
	//프린트하기
	function Print()
	{
		var fm = document.form1;
		//if(<%=vt_size%> == 0)		{ alert('검색데이타가 없습니다. 먼저 검색하여 주십시오.'); 	fm.st_dt.focus(); 	return; }	
		fm.target = "_blank";
		fm.action = "ic6_c5_print.jsp";	
		fm.submit();
	}	
	
	//당일마감하기
	function save()
	{
		var fm = document.form1;
		var size = toInt(fm.size.value);
		var reg_chk = 0;
	
		if(confirm('마감 하시겠습니까?')){
			fm.target = "i_no";	
			fm.action = "/acct/rc/stat_acct_a.jsp";	
			fm.submit();
		}
	}	
	
	//평가일괄표시
	function cng_display(idx){
		var fm = document.form1;
		var size = toInt(fm.size.value);
		for(i=0; i<size; i++){
			if(size == 1){
				fm.result.options[idx].selected = true;
			}else{
				fm.result[i].options[idx].selected = true;
			}
		}
	}	
	
	//초기화면가기
	function f_init()
	{
		var fm = document.form1;
		fm.st_dt.value = '';
		fm.end_dt.value = '';
		fm.s_cnt.value = '';
		fm.target = "_self";
		fm.action = "ic6_c5.jsp";	
		fm.submit();
	}

//-->
</script>
</head>

<body leftmargin="15">
<form name="form1" method="post" action="">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='size' 	value='<%=vt_size%>'>
  <input type='hidden' name='acct_st' 	value='ic6_c5'>
  <input type='hidden' name='value_size' value='6'>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
        <td>
        	<table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acct/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acct/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>내부통제마감 > 전산관리Cycle > <span class=style5>PC접근통제관리</span></span></td>
                    <td width=7><img src=/acct/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
		<td>
			<table border=0 cellspacing=1>
				<tr> 
					<td>
						<!--기준기간-->
						  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acct/images/center/arrow_gjij.gif align=absmiddle>
						  <input type='text' size='12' name='st_dt' class='text' value='<%=AddUtil.ChangeDate2(st_dt)%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
						  ~ 
						  <input type='text' size='12' name='end_dt' class='text' value='<%=AddUtil.ChangeDate2(end_dt)%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
						  <!--샘플수-->
						  &nbsp;&nbsp;&nbsp;&nbsp;
						  <img src=/acct/images/center/arrow_nsp.gif align=absmiddle> 
						  <input type='text' size='3' name='s_cnt' class='text' value="<%=s_cnt%>">개
						  <!--검색버튼-->
						  &nbsp;&nbsp;&nbsp;&nbsp;
						  <a href="javascript:Search();"><img src=/acct/images/center/button_search.gif align=absmiddle border=0></a>
						  <!--출력버튼-->
						  <%//if(vt_size>0){%>
						  &nbsp;&nbsp;&nbsp;&nbsp;
						  <a href="javascript:Print();"><img src=/acct/images/center/button_print.gif align=absmiddle border=0></a>
						  <%//}%>
					</td>
				</tr>
			</table>
		</td>
    </tr>  
	<tr>
        <td class=h></td>
    </tr>
	<tr>
		<td class=line2 ></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
					<tr>
					  <td class="title" rowspan="2">No.</td>
					  <td class="title" colspan="2" rowspan="1">일일점검일지</td>
					  <td class="title" colspan="4" rowspan="1">일일점검일지</td>
					</tr>
					<tr>
					  <td class="title">점검일</td>
					  <td class="title">점검자</td>
					  <td class="title">(1)</td>
					  <td class="title">(2)</td>
					  <td class="title">(3)</td>
					  <td class="title">(4)</td>
					</tr>
					<%if( vt.size() == 0){%>
					<%	for(int i = 0 ; i < vt_size ; i++){%>
					<input type='hidden' name="seq" 	value="<%=i+1%>">	  
					<input type='hidden' name="value7" 	value="">
					<input type='hidden' name="value8" 	value="">
					<input type='hidden' name="value9" 	value="">
					<input type='hidden' name="value10" 	value="">
					<input type='hidden' name="value11" 	value="">
					<input type='hidden' name="value12" 	value="">
					<input type='hidden' name="value13" 	value="">
					<input type='hidden' name="value14" 	value="">
					<input type='hidden' name="value15" 	value="">
					<input type='hidden' name="value16" 	value="">
					<input type='hidden' name="value17" 	value="">			
					<input type='hidden' name="value18" 	value="">
					<input type='hidden' name="value19" 	value="">
					<input type='hidden' name="value20" 	value="">
					<input type='hidden' name="result" 	value="">
					<tr>
					  <td align='center'><%=i+1%></td>
					  <td align='center'><input type='text' size='20' name='value1' class='text' value=""></td>
					  <td align='center'><input type='text' size='20' name='value2' class='text' value=""></td>
					  <td align='center'><input type='text' size='20' name='value3' class='text' value=""></td>
					  <td align='center'><input type='text' size='20' name='value4' class='text' value=""></td>
					  <td align='center'><input type='text' size='20' name='value5' class='text' value=""></td>
					  <td align='center'><input type='text' size='20' name='value6' class='text' value=""></td>
					</tr>
					<%}%>
					<%}%>
					<%if( vt.size() > 0){%>
					<%	for(int i = 0 ; i < vt_size ; i++){	
						Hashtable ht = (Hashtable)vt.elementAt(i);%>
					<input type='hidden' name="seq" 	value="<%=i+1%>">	  
					<input type='hidden' name="value7" 	value="">
					<input type='hidden' name="value8" 	value="">
					<input type='hidden' name="value9" 	value="">
					<input type='hidden' name="value10" 	value="">
					<input type='hidden' name="value11" 	value="">
					<input type='hidden' name="value12" 	value="">
					<input type='hidden' name="value13" 	value="">
					<input type='hidden' name="value14" 	value="">
					<input type='hidden' name="value15" 	value="">
					<input type='hidden' name="value16" 	value="">
					<input type='hidden' name="value17" 	value="">			
					<input type='hidden' name="value18" 	value="">
					<input type='hidden' name="value19" 	value="">
					<input type='hidden' name="value20" 	value="">
					<input type='hidden' name="result" 	value="">
					<tr>
					  <td align='center'><%=i+1%></td>
					  <td align='center'><input type='text' size='20' name='value1' class='text' value="<%=ht.get("VALUE1")%>"></td>
					  <td align='center'><input type='text' size='20' name='value2' class='text' value="<%=ht.get("VALUE2")%>"></td>
					  <td align='center'><input type='text' size='20' name='value3' class='text' value="<%=ht.get("VALUE3")%>"></td>
					  <td align='center'><input type='text' size='20' name='value4' class='text' value="<%=ht.get("VALUE4")%>"></td>
					  <td align='center'><input type='text' size='20' name='value5' class='text' value="<%=ht.get("VALUE5")%>"></td>
					  <td align='center'><input type='text' size='20' name='value6' class='text' value="<%=ht.get("VALUE6")%>"></td>
					</tr>	
					<%}%>
					<%}%>
			</table>
		</td>
	</tr>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
				  <td>Test 결과(예외사항 수 / 샘플 수)</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
      <td class=h ></td>
    </tr>    
    <tr>
      <td align="right"><a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acct/images/center/button_dimg.gif border=0 align=absmiddle></a></td></td>
    <tr>
</table>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
