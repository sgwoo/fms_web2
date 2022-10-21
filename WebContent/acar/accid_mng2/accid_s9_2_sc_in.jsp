<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.accid.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	
	String gubun1 	= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")	==null?"":request.getParameter("gubun6");
	String gubun7 	= request.getParameter("gubun7")	==null?"":request.getParameter("gubun7");
	String st_dt 	= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 	= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String asc 	= request.getParameter("asc")		==null?"":request.getParameter("asc");
	String go_url 	= request.getParameter("go_url")	==null?"":request.getParameter("go_url");
	String idx 	= request.getParameter("idx")		==null?"":request.getParameter("idx");
	
	//height
	int sh_height 	= request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이				


	CommonDataBase c_db = CommonDataBase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();
		
	
	Vector accids = as_db.getAccidS9_2List(gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, gubun7, st_dt, end_dt, s_kd, t_wd, sort, asc);
	int accid_size = accids.size();
	
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents()
	{
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    	var X ;
	    	document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    	document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    	document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='accid_size' value='<%=accid_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width='1580'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='430' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>					
                    <td width='50' class='title'>연번</td>
                    <td width='90' class='title'>사고차량</td>
        	    <td width='90' class='title'>대차차량</td>
        	    <td width='70' class='title'>사고유형</td>
        	    <td width='130' class='title'>사고일자</td>
        	</tr>
	        </table>
	    </td>
	    <td class='line' width='1150'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='120' class='title'>상대보험사</td>
                    <td width='80' class='title'>청구일자</td>			
                    <td width='80' class='title'>청구금액</td>
                    <td width='80' class='title'>입금금액</td>
					<td width='80' class='title'>비율</td>					
                    <td width='80' class='title'>입금일자</td>			
                    <td width='80' class='title'>차액</td>
                    <td width='80' class='title'>연체이자</td>
                    <td width='80' class='title'>연체일수</td>
                    <td width='80' class='title'>총미납금액</td>
                    <td width='80' class='title'>공문요청일</td>
                    <td width='80' class='title'>공문작성일</td>
                    <td width='90' class='title'>최고서작성</td>
                    <td width='60' class='title'>청구담당</td>			
                </tr>
            </table>
	    </td>
    </tr>
<%	if(accid_size > 0){%>
    <tr>
	<td class='line' width='430' id='td_con' style='position:relative;'>			
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <% 		for (int i = 0 ; i < accid_size ; i++){
				Hashtable accid = (Hashtable)accids.elementAt(i);
				String req_st = String.valueOf(accid.get("REQ_ST"));%>
          <tr> 
            <td width='50' align='center' ><a name="<%=i+1%>"><%=i+1%></a></td>
            <td width='90' align='center' ><%=accid.get("CAR_NO")%></td>
            <td width='90' align='center' ><%=accid.get("D_CAR_NO")%></td>
            <td width='70' align='center' ><%=accid.get("ACCID_ST_NM")%></td>
            <td width='130' align='center' ><%=AddUtil.ChangeDate3(String.valueOf(accid.get("ACCID_DT")))%></td>
          </tr>
          <%		}%>
          <tr> 
            <td class=title colspan="5" align='center'>&nbsp;</td>
          </tr>
        </table>
	</td>
	<td class='line' width='1150'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%		for (int i = 0 ; i < accid_size ; i++){
				Hashtable accid = (Hashtable)accids.elementAt(i);
				String req_st = String.valueOf(accid.get("REQ_ST"));
				long t_req_amt = AddUtil.parseLong(String.valueOf(accid.get("DEF_AMT")))+AddUtil.parseLong(String.valueOf(accid.get("DLY_AMT")));
				
				%>
          <tr> 
            <td width='120' align='center' ><span title='<%=accid.get("INS_COM")%>'><%=Util.subData(String.valueOf(accid.get("INS_COM")), 8)%></span></td>			
            <td width='80' align='center' ><%=AddUtil.ChangeDate2(String.valueOf(accid.get("REQ_DT")))%></td>			
            <td width='80' align='right' ><%=Util.parseDecimal(String.valueOf(accid.get("REQ_AMT")))%></td>
            <td width='80' align='right' ><%=Util.parseDecimal(String.valueOf(accid.get("PAY_AMT")))%></td>			
			<td width='80' align='right' ><%=accid.get("DEF_PER2")%> %</td>			
            <td width='80' align='center' ><%=AddUtil.ChangeDate2(String.valueOf(accid.get("PAY_DT")))%></td>
            <td width='80' align='right' ><%=Util.parseDecimal(String.valueOf(accid.get("DEF_AMT")))%></td>
            <td width='80' align='right' ><%=Util.parseDecimal(String.valueOf(accid.get("DLY_AMT")))%></td>
            <td width='80' align='right' ><%=accid.get("DLY_DAYS")%></td>
            <td width='80' align='right' ><%=Util.parseDecimal(t_req_amt)%></td>
            <td width='80' align='center' ><%=AddUtil.ChangeDate2(String.valueOf(accid.get("DOC_REQ_DT")))%></td>
            <td width='80' align='center' ><%=AddUtil.ChangeDate2(String.valueOf(accid.get("DOC_REG_DT")))%></td>						
            <td width='90' align='center' ><%=AddUtil.ChangeDate2(String.valueOf(accid.get("F_DOC_REG_DT")))%><%if(!String.valueOf(accid.get("F_DOC_REG_DT")).equals("")){%>(<%=accid.get("F_DOC_CNT")%>)<%}%></td>						
            <td width='60' align='center' ><%=c_db.getNameById(String.valueOf(accid.get("BUS_ID2")),"USER")%></td>
          </tr>
          <%			total_amt1 = total_amt1 + AddUtil.parseLong(String.valueOf(accid.get("REQ_AMT")));
		 		total_amt2 = total_amt2 + AddUtil.parseLong(String.valueOf(accid.get("PAY_AMT")));
				total_amt3 = total_amt3 + AddUtil.parseLong(String.valueOf(accid.get("DEF_AMT")));
				total_amt4 = total_amt4 + AddUtil.parseLong(String.valueOf(accid.get("DLY_AMT")));
				total_amt5 = total_amt5 + t_req_amt;
		  	}%>
          <tr> 
            <td class=title align='center' colspan='2'>합계</td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>			
            <td class=title align='center'>&nbsp;</td>
			<td class=title align='center'>&nbsp;</td>
            <td class=title style='text-align:right'><%=Util.parseDecimal(total_amt3)%></td>						
            <td class=title style='text-align:right'><%=Util.parseDecimal(total_amt4)%></td>						
            <td class=title align='center'>&nbsp;</td>					
            <td class=title style='text-align:right'><%=Util.parseDecimal(total_amt5)%></td>						                                    
            <td class=title align='center'>&nbsp;</td>			
            <td class=title align='center'>&nbsp;</td>						
            <td class=title align='center'>&nbsp;</td>						
            <td class=title align='center'>&nbsp;</td>						
          </tr>
        </table>
	</td>
  </tr>
<%	}else{%>                     
  <tr>
	<td class='line' width='430' id='td_con' style='position:relative;'>			
      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
		  <td align='center'>등록된 데이타가 없습니다</td>
		</tr>
	  </table>
	</td>
	<td class='line' width='1150'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
		  <td>&nbsp;</td>
		</tr>
	  </table>
	</td>
  </tr>
<% 	}%>
</table>
<script language='javascript'>
<!--
//-->
</script>
</form>
</body>
</html>
