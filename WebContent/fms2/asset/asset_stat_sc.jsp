<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.asset.*"%>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");

	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");  //기수 
//	String gubun2 	= request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 1; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-80;//현황 라인수만큼 제한 아이프레임 사이즈
	
	AssetDatabase as_db = AssetDatabase.getInstance();
	
	//자산상각액
	Vector asset = as_db.getAssetDepStat(gubun1);
	int asset_size = asset.size();
		
	
	long sum1 = 0;
	long sum2 = 0;
	long sum3 = 0;
	long sum4 = 0;	
	long sum5 = 0;  //그린카  
	long sum6 = 0;			   	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
 	//계약서 내용 보기
	function view_asset(asset_ym, gubun1){
			window.open('view_assetdep_list.jsp?asset_ym='+asset_ym+'&gubun1='+gubun1, "ASSETDEP_LIST", "left=30, top=30, width=950, height=700, resizable=yes, scrollbars=yes, status=yes");
	}
	
			
//-->
</script>
</head>

<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='asset_code' value=''>
   
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr><td class=line2></td></tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>			  
                <tr>
                    <td width='16%' rowspan="2" class='title'>년월</td>
                    <td class='title' colspan=2 >합계</td>
                    <td class='title' colspan=2 >리스사업자동차</td>
                    <td class='title' colspan=2 >렌트사업자동차</td>
                </tr>
                <tr>
                    <td class='title' width="14%">상각비용</td>
                    <td class='title' width="14%">구매보조금</td>
                    <td class='title' width="14%">상각비용</td>
                    <td class='title' width="14%">구매보조금</td>
                    <td class='title' width="14%">상각비용</td>
                    <td class='title' width="14%">구매보조금</td>
                </tr>
          <%	for(int i = 0 ; i < asset_size ; i++){
					Hashtable ht = (Hashtable)asset.elementAt(i);%>		  
                <tr> 
                    <td align="center"><%=ht.get("YM")%></td>
                    <td align="right"><%=Util.parseDecimal(Util.parseLong(String.valueOf(ht.get("AMT1")))+ Util.parseLong(String.valueOf(ht.get("AMT2"))) )%></td>
                    <td align="right"><%=Util.parseDecimal(Util.parseLong(String.valueOf(ht.get("G_AMT1")))+ Util.parseLong(String.valueOf(ht.get("G_AMT2")))  )%></td>
                    <td align="right"><a href="javascript:view_asset('<%=ht.get("YM")%>','1')"><%=Util.parseDecimal(Util.parseLong(String.valueOf(ht.get("AMT1")))  )%></a></td>
                    <td align="right"><a href="javascript:view_asset('<%=ht.get("YM")%>','1')"><%=Util.parseDecimal(Util.parseLong(String.valueOf(ht.get("G_AMT1")))  )%></a></td>
                    <td align="right"><a href="javascript:view_asset('<%=ht.get("YM")%>','2')"><%=Util.parseDecimal(Util.parseLong(String.valueOf(ht.get("AMT2")))   )%></a></td>
                    <td align="right"><a href="javascript:view_asset('<%=ht.get("YM")%>','2')"><%=Util.parseDecimal(Util.parseLong(String.valueOf(ht.get("G_AMT2")))  )%></a></td>
                </tr>
<%			
	
			sum2 = sum2 + Util.parseLong(String.valueOf(ht.get("AMT1")));
			sum4 = sum4 + Util.parseLong(String.valueOf(ht.get("AMT2")));
			
			sum5 = sum5 + Util.parseLong(String.valueOf(ht.get("G_AMT1")));
			sum6 = sum6 + Util.parseLong(String.valueOf(ht.get("G_AMT2")));
}%>			  
                <tr> 
                    <td class=title align="center">계</td>
         
                    <td class=title style="text-align:right"><%=Util.parseDecimal(sum2+sum4 )%></td>
                    <td class=title style="text-align:right"><%=Util.parseDecimal(sum5+sum6)%></td>
                    <td class=title style="text-align:right"><%=Util.parseDecimal(sum2  )%></td>
                    <td class=title style="text-align:right"><%=Util.parseDecimal(sum5 )%></td>
                    <td class=title style="text-align:right"><%=Util.parseDecimal(sum4 )%></td>
                    <td class=title style="text-align:right"><%=Util.parseDecimal(sum6 )%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
</table>
</form>
</body>
</html>
