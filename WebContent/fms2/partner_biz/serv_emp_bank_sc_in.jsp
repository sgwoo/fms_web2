<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*" %>
<%@ page import="acar.partner.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String list_order = request.getParameter("list_order")==null?"1":request.getParameter("list_order");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");	
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	Serv_EmpDatabase se_dt = Serv_EmpDatabase.getInstance();
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "35", "01", "");
	
	String save_dt = ad_db.getMaxSaveDt("stat_debt");
	
	Vector vt = se_dt.getServ_offList_20150416(s_kd, t_wd, gubun1, gubun2, sort_gubun, sort, "1", save_dt, list_order);
	int vt_size = vt.size();
	
	
	int vc_size =0;
	
	String newyn = "";
	long jan_tot_amt = 0;
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script language="JavaScript">
<!--
//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}	
		}
		return;
	}
	
	//선택메일 보내기 
	function SendMail2(kd){
		
		var fm = document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}
	
		if(cnt < 2){
		   	alert("최소 2곳이상 선택하세요.");
		   return;
		}
			
		window.open('about:blank', "SendMail", "left=0, top=0, width=650, height=550, scrollbars=yes, status=yes, resizable=yes");
		alert("선택하신 금융기관에만 보냅니다.");
		if(!confirm('메일을 발송 하시겠습니까?')){	return; }
		fm.target = "SendMail";
		fm.action = "mail_fin_m.jsp?gubun1="+ kd+"&cnt="+cnt;
	   fm.submit();	
	 	
	}
	
	//리스트 엑셀 전환
	function pop_excel(){
		var fm = document.form1;
		fm.target = "_blank";
		fm.action = "popup_fin_man_search_excel.jsp";
		fm.submit();
	}
	
//-->
</script>
</head>

<body>
<form name="form1" action="" method="post">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="gubun2" value="<%=gubun2%>">
<input type="hidden" name="sort_gubun" value="<%=sort_gubun%>">
<input type="hidden" name="sort" value="<%=sort%>">
<input type="hidden" name="save_dt" value="<%=save_dt%>">
<input type="hidden" name="list_order" value="<%=list_order%>">
<table border=0 cellspacing=0 cellpadding=0 width='100%'>
	<%if(gubun1.equals("0001")){%>
		<input type="button" class="button" value="메일발송" onclick="SendMail2('<%=gubun1%>')"/>
		<% } %>
		&nbsp;<input type="button" class="button" value="검색결과 엑셀저장" onclick="pop_excel();"/>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr> 
					<td width='5%' class='title'>연번<%if(gubun1.equals("0001")){%><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"><%}%></td>
					<td width='10%' class='title'>관리구분</td>
					<td width='20%' class='title'>상호</td>
					<td width='10%' class='title'>지점구분</td>
					<td width='10%' class='title'>전화번호</td>
					<td width='10%' class='title'>거래내용</td>
					<td width="10%" class='title'>최초등록일</td>
					<td width="10%" class='title'>변경등록일</td>
					<td width="10%" class='title'>대출거래잔액<br>(<%=AddUtil.ChangeDate2(String.valueOf(save_dt))%>)</td>
				</tr>
			</table>
		</td>
	</tr>
<%if(vt_size !=0 ){%>
	<tr>            
		<td class=line> 
			<table border="0" cellspacing="1" cellpadding="0" width=100% >
              <% for(int i=0; i< vt_size; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					
					
					Hashtable seu = se_dt.getServ_emp_udt(String.valueOf(ht.get("OFF_ID")));
					String upt_dt = String.valueOf(seu.get("UPT_DT"));
					if(upt_dt.equals("null")){
						upt_dt = "";
					}
					
					if(gubun1.equals("0001")){
						Vector vc = se_dt.Count_serv_bc_item(String.valueOf(ht.get("OFF_ID")));
						vc_size = vc.size();
							for(int c=0; c< vc_size; c++){
								Hashtable hc = (Hashtable)vc.elementAt(c);
								
									newyn = String.valueOf(hc.get("NEWYN"));

							}
					}
					
					jan_tot_amt += Util.parseLong(String.valueOf(ht.get("OVER_MON_AMT")));
				
				%>
				<tr> 
					<td width='5%' align='center'><%=i+1%><%if(gubun1.equals("0001")){%><input type="checkbox" name="ch_cd" value="<%=ht.get("OFF_NM")%>^<%=ht.get("OFF_ID")%>"><%}%></td>
					<td width='10%' align='center'><%=ht.get("NM_CD")%></td>
					<td width='20%' align='center'><span title='<%=ht.get("OFF_NM")%>'>&nbsp;<a href="javascript:parent.view_detail('<%=ht.get("OFF_ID")%>','<%=ht.get("CPT_CD")%>','<%=ht.get("OVER_MON_AMT")%>','<%=AddUtil.ChangeDate2(String.valueOf(save_dt))%>')"><%=AddUtil.subData(String.valueOf(ht.get("OFF_NM")),10)%><%if(vc_size > 0){%><font color="red">(<%=vc_size%>) <%=newyn%></font><%}%></a></span></td>
					<td width='10%' align='center'><%if(ht.get("BR_ID").equals("S1")){%>본점<%}else if(ht.get("BR_ID").equals("B1")){%>지점<%}%></td>
					<td width='10%' align='center'><%=ht.get("OFF_TEL")%></td>
					<td width='10%' align='center'><%=ht.get("NOTE")%></td>
					<td width='10%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
					<td width='10%' align='center'><%=AddUtil.ChangeDate2(upt_dt)%></td>
					<td width='10%' align='right'><%=AddUtil.parseDecimal2(String.valueOf(ht.get("OVER_MON_AMT")))%>&nbsp;</td>
				</tr>
				<%}%>
				<tr>
					<td width='10%' class="title" colspan="8">대출거래잔액 합계</td>
					<td width='10%' align='right'><%=Util.parseDecimal(jan_tot_amt)%>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%}else{%>
	<tr>	        
		<td class='line'> 
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr> 
					<td align='left' >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;해당 업체가 없습니다.</td>
				</tr>          
			</table>
		</td>
	</tr>
<%}%>

</table>		
</form>
</body>
</html>
