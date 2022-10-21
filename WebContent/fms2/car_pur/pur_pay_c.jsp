<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.cus0601.*" %>
<%@ page import="acar.util.*, acar.user_mng.*, acar.doc_settle.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String trf_st 	= request.getParameter("trf_st")==null?"":request.getParameter("trf_st");
	String pur_pay_dt= request.getParameter("pur_pay_dt")==null?"":request.getParameter("pur_pay_dt");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//out.println(trf_st);
	
	
	Vector vt = d_db.getCarPurPayDtList(trf_st, pur_pay_dt);
	int vt_size = vt.size();
	
	Vector vt2 = d_db.getCarPurPayDtStat(trf_st, pur_pay_dt);
	int vt_size2 = vt2.size();
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;
	long total_amt9 = 0;
	long total_amt10 = 0;
	long total_amt11 = 0;
	long total_amt12 = 0;
	long total_amt13 = 0;
	long total_amt14 = 0;
	long total_amt15 = 0;
	long total_amt16 = 0;
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function view_pur_doc(rent_mng_id, rent_l_cd){
		var SUBWIN= "/fms2/car_pur/pur_doc_u.jsp?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&mode=view";
		window.open(SUBWIN, "View_PUR_DOC", "left=50, top=50, width=1000, height=700, resizable=yes, scrollbars=yes, status=yes");	
	}

	//영업사원보기
	function view_car_office(car_off_id){
		var fm = document.form1;
		window.open("view_car_office.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/car_pur/pur_pay_i.jsp&cmd=view&car_off_id="+car_off_id, "VIEW_CAR_OFF", "left=50, top=50, width=850, height=200, resizable=yes, scrollbars=yes, status=yes");
	}
	
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
		
	function save(){
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
		if(cnt == 0){
		 	alert("지출할 계약을 선택하세요.");
			return;
		}	
				
		if(confirm('처리하시겠습니까?')){	
			fm.action='pur_pay_i_a.jsp';		
//			fm.target='i_no';
			fm.submit();
		}									
	}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name="mode" 		value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>">
  <input type='hidden' name='trf_st' 	value='<%=trf_st%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=980>
    <tr>
      <td>&lt; 차량대금 지출 기처리 &gt; </td>
    </tr>  
    <tr>
      <td class=h></td>
    </tr>  
    <tr>
      <td>[지출일자] <%=AddUtil.ChangeDate2(pur_pay_dt)%></td>
    </tr>  	
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  	
    <tr>
      <td class='line'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr>
			<td width='30' class='title'>연번</td>
		    <td width='90' class='title'>계약번호</td>
		    <td width="110" class='title'>고객</td>
		    <td width="70" class='title'>출고일자</td>			
			<td width='80' class='title'>차량번호</td>
		    <td width="100" class='title'>차종</td>					
       		<td width='120' class='title'>지출처</td>
			<td width="60" class='title'>지급수단</td>
		    <td width="90" class='title'>금액</td>								
			<td width="80" class='title'>종류</td>				  
			<td width="150" class='title'>번호</td>
		  </tr>		
		  <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
		  %>
		  <tr>
			<td align='center'><%=i+1%></td>
		    <td align='center'><a href="javascript:view_pur_doc('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td>
		    <td align='center'><%=ht.get("FIRM_NM")%></td>
		    <td align='center'><%=ht.get("DLV_DT")%></td>			
			<td align='center'><%=ht.get("CAR_NO")%></td>
       		<td align='center'><%=ht.get("CAR_NM")%></td>					
       		<td align='center'><font color="#CCCCCC"><%=c_db.getNameById(String.valueOf(ht.get("CAR_COMP_ID")),"CAR_COM")%></font><br><%=ht.get("DLV_BRCH")%></td>
			<td align='center'><%=ht.get("TRF_ST")%></td>
			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT")))%></td>
			<td align='center'><%=ht.get("CARD_KIND")%><%//if(!String.valueOf(ht.get("TRF_ST")).equals("계약금") && String.valueOf(ht.get("CARD_KIND")).equals("")){%><%//=ht.get("BANK")%><%//}%></td>
			<td align='center'><%=ht.get("CARDNO")%><%//if(!String.valueOf(ht.get("TRF_ST")).equals("계약금") && String.valueOf(ht.get("CARDNO")).equals("")){%><%//=ht.get("ACC_NO")%><%//}%></td>						
		  </tr>
		  <%		total_amt1 	= total_amt1 + Long.parseLong(String.valueOf(ht.get("TRF_AMT")));
		 		}%>
		  <tr>
		    <td colspan="8" class=title>합계</td>
		    <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>		
			<td class='title'></td>									
			<td class='title'></td>												
		  </tr>
		</table>
	  </td>
    </tr> 
    <tr>
      <td class=h></td>
    </tr>  	
    <tr>
      <td>&nbsp;<카드별 집계></td>
    </tr>  
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  	
    <tr>
      <td class='line'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr>
			<td width='30' class='title'>연번</td>
			<td width="100" class='title'>종류</td>				  
			<td width="300" class='title'>번호</td>
			<td width="100" class='title'>한도금액</td>				  						
			<td width="100" class='title'>만기일자</td>				  			
		    <td width="350" class='title'>금액</td>											
		  </tr>		
		  <%	total_amt1 = 0;
		  		for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vt2.elementAt(i);
		  %>
		  <tr>
			<td align='center'><%=i+1%></td>
			<td align='center'><%=ht.get("CARD_KIND")%></td>
			<td align='center'><%=ht.get("CARDNO")%></td>	
			<td align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("LIMIT_AMT")))%></td>					
			<td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CARD_EDATE")))%></td>									
			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT")))%></td>
		  </tr>
		  <%		total_amt1 	= total_amt1 + Long.parseLong(String.valueOf(ht.get("TRF_AMT")));
		 		}%>
		  <tr>
		    <td colspan="5" class=title>합계</td>
		    <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>		
		  </tr>
		</table>
	  </td>
    </tr>  	
	<tr>
		<td align="right">
		  <a href="javascript:print();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_print.gif align=absmiddle border=0></a><font color="#666666">(가로출력)</font>&nbsp;&nbsp;
		  <a href="javascript:window.close();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>	
	</tr>				  
  </table>
</form>  
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>
