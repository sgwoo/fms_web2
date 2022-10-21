<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.consignment.*, acar.user_mng.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	String cons_no 	= request.getParameter("cons_no")==null?"":request.getParameter("cons_no");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");


	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	String white = "";
	String disabled = "";
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector vt = new Vector();
	
	if (!t_wd.equals("")){
		vt = cs_db.getConsignmentMngList("4", t_wd, gubun1, st_dt, end_dt, gubun2);
	}
	
	int vt_size = vt.size();
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;	//세차수수료(20190517)
	
	if(nm_db.getWorkAuthUser("아마존카이외",user_id)){
		white = "white";
		disabled = "disabled";
	}
%>

<html>
<head><title>FMS</title>
<script language='javascript'>

function cons_memo(cons, seq)
	{
		window.open("cons_memo.jsp?cons_no="+cons+"&seq="+seq, "cons_memo", "left=10, top=10, width=650, height=300, scrollbars=yes, status=yes, resizable=yes");
	}	
	
function search()
{
	var fm = document.form1;
	
	if (fm.t_wd.value  == "") { 
		alert("차량번호를 입력하세요.!!");
		return;
	}
	
	fm.action = "cons_reg_back_list.jsp";
	fm.submit();
}

function enter() 
{
	var keyValue = event.keyCode;
	if (keyValue =='13') search();
}
function init_back_list(cons_no, car_mng_id, cons_su)
{
	var fm = opener.form1;
	fm.cons_no.value=cons_no
	fm.cons_su.value=cons_su;//
	fm.target='_self';
         fm.action='/fms2/consignment_new/cons_reg_step1.jsp';
	fm.submit();
	self.close();
	}
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>	
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='cons_no' value='<%=cons_no%>'>
  <input type='hidden' name='mode' value=''>    
  <input type='hidden' name='req_dt' value='<%=AddUtil.getDate()%>'>      
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
  	<tr>
  		<td class=line2 colspan="2"></td>
  	</tr>
	<tr>
        <td colspan="2" class=line>
	        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title>차량번호</td>
                    <td width=90% >&nbsp;&nbsp;
        			    <input type='text' name='t_wd' size='20' class="text" value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active' >
            			&nbsp;&nbsp;&nbsp;
        		    	<a href="javascript:search();" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif" style="border:0px; vertical-align: bottom;"></a>
        		    </td>
                </tr>
            </table>
	    </td>
    </tr>  
    <tr align="right">
        <td colspan="2"></td>
    </tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width="3%" rowspan="2" class='title' style='height:45'>연번</td>
					<td width="4%" rowspan="2" class='title'>상태</td>
					<td width="9%" rowspan="2" class='title'>탁송번호</td>				  
					<td width="9%" rowspan="2" class='title'>탁송업체</td>
					<td width="4%" rowspan="2" class='title'>구분</td>
					<td width="6%" rowspan="2" class='title'>차량번호</td>				  
					<td width="9%" rowspan="2" rowspan="2" class='title'>차명</td>
					<td width="" rowspan="2" class='title'>상호</td>				  
					<td width="8%" rowspan="2" class='title'>탁송사유</td>				  									
					<td colspan="2" class='title'>출발</td>
					<td colspan="2" class='title'>도착</td>
				</tr>
				<tr>
					<td width="9%" class='title'>장소</td>
					<td width="10%" class='title'>시간</td>
					<td width="9%" class='title'>장소</td>
					<td width="10%" class='title'>시간</td>
				</tr>
			</table>
		</td>
	</tr>
<%	if(vt_size > 0)	{%>
	<tr>
		<td class='line' width='100%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>		
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			%> 
				<tr>
					<td  width='3%' align='center'><%if(ht.get("OFF_NM").equals("(주)아마존탁송")){%><a href="javascript:cons_memo('<%=ht.get("CONS_NO")%>','<%=ht.get("SEQ")%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><%}%><%=i+1%></a></td>
					<td  width='4%' align='center'><%=ht.get("STEP")%></td>					
					<td  width='9%' align='center'><a href="javascript:init_back_list(<%=ht.get("CONS_NO")%>,<%=ht.get("CAR_MNG_ID")%>,<%=ht.get("CONS_SU")%>)" onMouseOver="window.status=''; return true"><%=ht.get("CONS_NO")%>-<%=ht.get("SEQ")%></a></td>					
					<td  width='9%' align='center'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 6)%></td>
					<td  width='4%' align='center'><%=ht.get("CONS_ST_NM")%></td>					
					<td  width='6%' align='center'><%=Util.subData(String.valueOf(ht.get("CAR_NO")), 8)%></td>
					<td  width='9%' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 8)%></span></td>
					<td  width='' align='center'><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 8)%></span></td>
					<td  width='8%' align='center'><%=ht.get("CONS_CAU_NM")%></td>
					<td  width='9%' align='center'><span title='<%=ht.get("FROM_PLACE")%>'><%=Util.subData(String.valueOf(ht.get("FROM_PLACE")), 6)%></span></td>
					<td  width='10%' align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("F_DT")))%></td>
					<td  width='9%' align='center'><span title='<%=ht.get("TO_PLACE")%>'><%=Util.subData(String.valueOf(ht.get("TO_PLACE")), 6)%></span></td>
					<td  width='10%' align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("T_DT")))%></td>						
				</tr>
<%			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("CONS_AMT")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT")));
			total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("WASH_AMT")));
			total_amt4 	= total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("OTHER_AMT")));
			total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("TOT_AMT")));
			total_amt7 	= total_amt7 + AddUtil.parseLong(String.valueOf(ht.get("OIL_CARD_AMT")));
		}%>										
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>					
				    <td class='title'>&nbsp;</td>					
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>					
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>	
					<td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				</tr>				
			</table>
		</td>
	</tr>
<%	}else{%>
	<tr>
		<td class='line' width='18%' id='td_con' >
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%>
					</td>
				</tr>
			</table>
		</td>
	</tr>
<%	}%>
</table>
</form>
</body>
</html>
