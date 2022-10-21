<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>

<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String search_kd = request.getParameter("search_kd")==null?"":request.getParameter("search_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String bus_id2 = request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
%>
  <table width="800" border="0" cellspacing="1" cellpadding="0">
    <tr> 
      <td><table width="800" border="0" cellspacing="1" cellpadding="0">
          <tr> 
            <td class="line"><TABLE align=center border=0 width=800 cellspacing=1 cellpadding=0>
                <TR> 
                  <TD width=170 class="title">강주원</TD>
                  
                <TD width=150 align="center">53% (30/59)</TD>
                  <TD><img src=../../images/result1.gif width=200 height=10></TD>
                </TR>
                <TR> 
                  <TD class="title">김욱</TD>
                  <TD align="center">55% (30/57)</TD>
                  <TD bgcolor=#E7E7E7><img src=../../images/result1.gif width=220 height=10></TD>
                </TR>
                <TR> 
                  <TD class="title"><a href="0401_main_per.jsp">이광희</a></TD>
                  <TD align="center">57% (30/55)</TD>
                  <TD bgcolor=#E7E7E7><img src=../../images/result1.gif width=240 height=10></TD>
                </TR>
                <TR> 
                  <TD class="title">황수연</TD>
                  <TD align="center">61% (30/53)</TD>
                  <TD bgcolor=#E7E7E7><img src=../../images/result1.gif width=260 height=10></TD>
                </TR>
                <TR> 
                  <TD class="title">김헌태</TD>
                  <TD align="center">63% (30/51)</TD>
                  <TD bgcolor=#E7E7E7><img src=../../images/result1.gif width=280 height=10></TD>
                </TR>
                <TR> 
                  <TD class="title">오성호</TD>
                  <TD align="center">65% (30/49)</TD>
                  <TD bgcolor=#E7E7E7><img src=../../images/result1.gif width=300 height=10></TD>
                </TR>
                <TR> 
                  <TD class="title">김광수</TD>
                  <TD align="center">67% (30/47)</TD>
                  <TD bgcolor=#E7E7E7><img src=../../images/result1.gif width=320 height=10></TD>
                </TR>
                <TR> 
                  <TD class="title">송민재</TD>
                  <TD align="center">69% (30/45)</TD>
                  <TD bgcolor=#E7E7E7><img src=../../images/result1.gif width=340 height=10></TD>
                </TR>
                <TR> 
                  <TD class="title">최준원</TD>
                  <TD align="center">71% (30/43)</TD>
                  <TD bgcolor=#E7E7E7><img src=../../images/result1.gif width=360 height=10></TD>
                </TR>
              </TABLE></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      
    <td>3.사원별 연체 현황 리스트</td>
    </tr>
    <tr> 
      <td><table width="800" border="0" cellspacing="1" cellpadding="0">
          <tr> 
            <td class="line">
            <table width="800" border="0" cellspacing="1" cellpadding="0">
              <tr> 
                <td width="50" class="title">연번</td>
                <td width="120" class="title">이름</td>
                <td width="120" class="title">연체건수</td>
                <td width="120" class="title"><strong>연체금액</strong></td>
                <td width="120" class="title">비율(%)</td>
                <td class="title">비고</td>
              </tr>
              <tr> 
                <td align="center"> 
                  <div align="center">1</div>
                </td>
                <td> 
                  <div align="center">강주원</div>
                </td>
                <td> 
                  <div align="center">59</div>
                </td>
                <td> 
                  <div align="center"><strong>30</strong></div>
                </td>
                <td> 
                  <div align="center">29</div>
                </td>
                <td> 
                  <div align="center">53</div>
                </td>
              </tr>
              <tr> 
                <td> 
                  <div align="center">2</div>
                </td>
                <td> 
                  <div align="center">김욱</div>
                </td>
                <td> 
                  <div align="center">57</div>
                </td>
                <td> 
                  <div align="center"><strong>30</strong></div>
                </td>
                <td> 
                  <div align="center">27</div>
                </td>
                <td> 
                  <div align="center">55</div>
                </td>
              </tr>
              <tr> 
                <td> 
                  <div align="center">3</div>
                </td>
                <td> 
                  <div align="center"><a href="0401_main_per.jsp">이광희</a></div>
                </td>
                <td> 
                  <div align="center">55</div>
                </td>
                <td> 
                  <div align="center"><strong>30</strong></div>
                </td>
                <td> 
                  <div align="center">25</div>
                </td>
                <td> 
                  <div align="center">57</div>
                </td>
              </tr>
              <tr> 
                <td height="6"> 
                  <div align="center">4</div>
                </td>
                <td height="6"> 
                  <div align="center">황수연</div>
                </td>
                <td height="6"> 
                  <div align="center">53</div>
                </td>
                <td height="6"> 
                  <div align="center"><strong>30</strong></div>
                </td>
                <td height="6"> 
                  <div align="center">23</div>
                </td>
                <td height="6"> 
                  <div align="center">61</div>
                </td>
              </tr>
              <tr> 
                <td> 
                  <div align="center">5</div>
                </td>
                <td> 
                  <div align="center">김헌태</div>
                </td>
                <td> 
                  <div align="center">51</div>
                </td>
                <td> 
                  <div align="center"><strong>30</strong></div>
                </td>
                <td> 
                  <div align="center">21</div>
                </td>
                <td> 
                  <div align="center">63</div>
                </td>
              </tr>
              <tr> 
                <td> 
                  <div align="center">6</div>
                </td>
                <td> 
                  <div align="center">오성호</div>
                </td>
                <td> 
                  <div align="center">49</div>
                </td>
                <td> 
                  <div align="center"><strong>30</strong></div>
                </td>
                <td> 
                  <div align="center">19</div>
                </td>
                <td> 
                  <div align="center">65</div>
                </td>
              </tr>
              <tr> 
                <td> 
                  <div align="center">7</div>
                </td>
                <td> 
                  <div align="center">송민재</div>
                </td>
                <td> 
                  <div align="center">47</div>
                </td>
                <td> 
                  <div align="center"><strong>30</strong></div>
                </td>
                <td> 
                  <div align="center">17</div>
                </td>
                <td> 
                  <div align="center">67</div>
                </td>
              </tr>
              <tr> 
                <td> 
                  <div align="center">8</div>
                </td>
                <td> 
                  <div align="center">김광수</div>
                </td>
                <td> 
                  <div align="center">45</div>
                </td>
                <td> 
                  <div align="center"><strong>30</strong></div>
                </td>
                <td> 
                  <div align="center">15</div>
                </td>
                <td> 
                  <div align="center">69</div>
                </td>
              </tr>
              <tr> 
                <td> 
                  <div align="center">9</div>
                </td>
                <td> 
                  <div align="center">최준원</div>
                </td>
                <td> 
                  <div align="center">43</div>
                </td>
                <td> 
                  <div align="center"><strong>30</strong></div>
                </td>
                <td> 
                  <div align="center">13</div>
                </td>
                <td> 
                  <div align="center">71</div>
                </td>
              </tr>
              <tr> 
                <td colspan="2" class="title"> 
                  <div align="center"></div>
                  합 계 </td>
                <td class="title"> 
                  <div align="center">459</div>
                </td>
                <td class="title"> 
                  <div align="center">270</div>
                </td>
                <td class="title"> 
                  <div align="center">189</div>
                </td>
                <td class="title"> 
                  <div align="center">63%</div>
                </td>
              </tr>
            </table>
          </td>
          </tr>
        </table></td>
    </tr>
  </table>
</body>
</html>
