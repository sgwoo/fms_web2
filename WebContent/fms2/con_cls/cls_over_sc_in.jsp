<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*,  acar.common.*" %>
<%@ page import="acar.credit.*" %>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<%
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"6":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	

	String dt = request.getParameter("dt")==null?"":request.getParameter("dt");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
		
	//초과운행부담금 리스트
	Vector clss = ac_db.getClsOverList(dt, st_dt, end_dt, gubun2);
	int cls_size = clss.size();
	
	long total_amt = 0;
		
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
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
    document.all.title.style.pixelTop = document.body.scrollTop ;
                                                                              
    document.all.title_col0.style.pixelLeft	= document.body.scrollLeft ; 
    document.all.D1_col.style.pixelLeft	= document.body.scrollLeft ;   
    
}
function init() {
	
	setupEvents();
}
//-->
</script>
</head>
<body rightmargin=0>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
		<td class='line'>			 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=3% class=title>연번</td>
                    <td width=6% class=title>구분</td>
                    <td width=8% class=title>계약번호</td>
                    <td width=15% class=title>상호</td>           
                    <td width=8% class=title>차량번호</td>
                    <td width=12% class=title>차종</td>
                    <td width=7% class=title>해지일자</td>
                    <td width=18% class=title>계약조건</td>
                    <td width=6% class=title>초과운행</td>
                    <td width=8% class=title>초과운행부담금</td>
                    <td width=7% class=title>담당자</td>
                </tr>


<%
    for(int i=0; i< cls_size; i++){
    	   Hashtable cls = (Hashtable)clss.elementAt(i);
    	   
    	   total_amt = total_amt + AddUtil.parseLong(String.valueOf(cls.get("OVER_AMT")));
    	 
%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=cls.get("CLS_ST_NM")%></td>
                    <td align="center"><%=cls.get("RENT_L_CD")%></td>
                    <td>&nbsp;<span title='<%=cls.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(cls.get("FIRM_NM")), 12)%></span></td>                   
                    <td align="center"><%= cls.get("CAR_NO") %></td>
                    <td>&nbsp;<%=cls.get("CAR_NM")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(cls.get("CLS_DT")) )%></td>
                    <td align="center">&nbsp;<%=Util.parseDecimal(String.valueOf(cls.get("AGREE_DIST")))%> km이하/1년, 1km초과시 <%=Util.parseDecimal(String.valueOf(cls.get("OVER_RUN_AMT")))%>원 </td>
                    <td align="right">&nbsp;<%=Util.parseDecimal(String.valueOf(cls.get("JUNG_DIST")))%></td>
                    <td align="right">&nbsp;<%=Util.parseDecimal(String.valueOf(cls.get("OVER_AMT")))%></td>
                    <td align="center"><%=c_db.getNameById(String.valueOf(cls.get("REG_ID")), "USER")%></td>
                </tr>               
                
        <%}%>        
              <tr> 
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>		  
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>			  
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%></td>
                    <td class="title">&nbsp;</td>
              
                </tr>
                
        <% if(cls_size == 0){ %>
                <tr> 
                    <td colspan="11" align="center"> &nbsp;등록된 데이타가 없습니다.</td>
                </tr>
        <%}%>
            </table>
        </td>            		            		
	</tr>
</table>
</body>
</html>